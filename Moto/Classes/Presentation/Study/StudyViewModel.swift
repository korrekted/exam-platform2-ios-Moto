//
//  StudyViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StudyViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var courseManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var questionManager = QuestionManager()
    private lazy var statsManager = StatsManagerCore()
    private lazy var flashcardsManager = FlashcardsManagerCore()
    
    lazy var sections = makeSections()
    lazy var activeSubscription = makeActiveSubscription()
    lazy var course = makeCourseName()
    lazy var brief = makeBrief()
    
    let selectedCourse = BehaviorRelay<Course?>(value: nil)
    lazy var config = makeConfig().share(replay: 1, scope: .forever)
    
    private lazy var currentCourse = makeCurrentCourse().share(replay: 1, scope: .forever)
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension StudyViewModel {
    func makeCurrentCourse() -> Observable<Course> {
        let saved = selectedCourse
            .compactMap { $0 }
        
        let defaultCourse = makeCourses()
            .asObservable()
            .compactMap { $0.first}
            .take(1)
        
        return defaultCourse
            .concat(saved)
            .do(onNext: { [weak self] in
                self?.courseManager.select(course: $0)
            })
    }
    
    func makeCourseName() -> Driver<Course> {
        return currentCourse
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeSections() -> Driver<[StudyCollectionSection]> {
        let modesTitle = makeTitle()
        let modes = makeModes()
        let trophy = makeTrophy()
        let courses = makeCoursesElements()
        let flashcards = makeFlashcards()
        
        return Driver
            .combineLatest(courses, modesTitle, modes, trophy, flashcards) { courses, modesTitle, modes, trophy, flashcards -> [StudyCollectionSection] in
                var result = [StudyCollectionSection]()
                
                result.append(courses)
                result.append(modesTitle)
                
                if let trophy = trophy {
                    result.append(trophy)
                }
                
                if let flashcards = flashcards {
                    result.append(flashcards)
                }
                
                result.append(modes)
                
                return result
            }
    }
    
    func makeCoursesElements() -> Driver<StudyCollectionSection> {
        let courses = Signal
            .merge(
                QuestionMediator.shared.testPassed,
                TestCloseMediator.shared.testClosed.map { _ in Void() },
                ProfileMediator.shared.rxUpdatedProfileLocale.map { _ in () }
            )
            .asObservable()
            .startWith(())
            .flatMapLatest { [weak self] _ -> Observable<[Course]> in
                guard let self = self else { return .never() }
                return self.makeCourses()
            }
        
        return Observable
            .combineLatest(courses, currentCourse)
            .map { elements, currentCourse in
                let courseElements = elements.map {
                    (course: $0, isSelected: $0.id == currentCourse.id)
                }
                return StudyCollectionSection(elements: [.courses(courseElements)])
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeCourses() -> Observable<[Course]> {
        func source() -> Single<[Course]> {
            courseManager
                .retrieveCourses()
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
            .trackActivity(activity)
    }
    
    func makeBrief() -> Driver<SCEBrief> {
        let testPassed = Signal
            .merge(
                QuestionMediator.shared.testPassed,
                TestCloseMediator.shared.testClosed.map { _ in Void() }
            )
            .asObservable()
            .startWith(())
        
        return Observable.combineLatest(testPassed, currentCourse)
            .flatMapLatest { [weak self] _, course -> Observable<(Course, Brief?)> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<(Course, Brief?)> {
                    self.statsManager
                        .retrieveBrief(courseId: course.id)
                        .map { (course, $0) }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .map { stub -> SCEBrief in
                let (course, brief) = stub
                
                var calendar = [SCEBrief.Day]()
                
                for n in 0...6 {
                    let date = Calendar.current.date(byAdding: .day, value: -n, to: Date()) ?? Date()
                    
                    let briefCalendar = brief?.calendar ?? []
                    let activity = briefCalendar.indices.contains(n) ? briefCalendar[n] : false
    
                    let day = SCEBrief.Day(date: date, activity: activity)
    
                    calendar.append(day)
                }
                
                calendar.reverse()
                
                return SCEBrief(courseName: course.name,
                                      streakDays: brief?.streak ?? 0,
                                      calendar: calendar)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeTitle() -> Driver<StudyCollectionSection> {
        currentCourse
            .map { StudyCollectionSection(elements: [.title($0.name)])}
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeModes() -> Driver<StudyCollectionSection> {
        Driver.just(StudyCollectionSection(elements: [.mode]))
    }
    
    func makeTrophy() -> Driver<StudyCollectionSection?> {
        activeSubscription
            .compactMap { $0 ? nil : StudyCollectionSection(elements: [.trophy]) }
    }
    
    func makeFlashcards() -> Driver<StudyCollectionSection?> {
        let isEmptyFlashcardsTopics = currentCourse
            .flatMapLatest { [weak self] course -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Bool> {
                    self.flashcardsManager
                        .obtainTopics(courseId: course.id)
                        .map { $0.isEmpty }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorJustReturn: true)
        
        let config = self.config
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .combineLatest(isEmptyFlashcardsTopics, config) { isEmptyFlashcardsTopics, config -> StudyCollectionSection? in
                guard !isEmptyFlashcardsTopics else {
                    return nil
                }
                
                let flashcards = SCEFlashcards(topicsToLearn: config.flashcardsCount,
                                               topicsLearned: config.flashcardsCompleted)
                
                return StudyCollectionSection(elements: [.flashcards(flashcards)])
            }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        let updated = SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .compactMap { $0?.activeSubscription }
            .asDriver(onErrorJustReturn: false)
        
        let initial = Driver<Bool>
            .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                let activeSubscription = this.sessionManager.getSession()?.activeSubscription ?? false
                
                return .just(activeSubscription)
            }
        
        return Driver
            .merge(initial, updated)
    }
    
    func makeConfig() -> Observable<CourseConfig> {
        currentCourse
            .flatMapLatest { [weak self] course -> Observable<CourseConfig> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<CourseConfig> {
                    self.questionManager
                        .obtainConfig(courseId: course.id)
                        .flatMap { config -> Single<CourseConfig> in
                            guard let config = config else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(config)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
    }
}
