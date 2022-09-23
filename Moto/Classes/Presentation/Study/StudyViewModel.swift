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
    
    private lazy var profileManager = ProfileManager()
    private lazy var courseManager = CoursesManager()
    private lazy var sessionManager = SessionManager()
    private lazy var questionManager = QuestionManager()
    private lazy var statsManager = StatsManagerCore()
    private lazy var flashcardsManager = FlashcardsManagerCore()
    
    lazy var sections = makeSections()
    lazy var activeSubscription = makeActiveSubscription()
    lazy var course = makeCourse()
    lazy var brief = makeBrief()
    
    let selectedCourse = BehaviorRelay<Course?>(value: nil)
    lazy var config = makeConfig().share(replay: 1, scope: .forever)
    
    private lazy var currentCourse = makeCurrentCourse().share(replay: 1, scope: .forever)
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension StudyViewModel {
    func makeCurrentCourse() -> Observable<Course> {
        func set(course: Course) -> Observable<Course> {
            func source() -> Single<Void> {
                profileManager
                    .set(selectedCourse: course)
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
                .map { course }
        }
        
        let initial = profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .asObservable()
            .flatMap { [weak self] selectedCourse -> Observable<Course> in
                guard let self = self else {
                    return .never()
                }
                
                if let selectedCourse = selectedCourse {
                    return .just(selectedCourse)
                }
                
                return self.makeCourses()
                    .map { $0.first }
                    .flatMapLatest { course -> Observable<Course> in
                        guard let course = course else {
                            return .never()
                        }
                        
                        return set(course: course)
                    }
            }
            .compactMap { $0 }
            .asObservable()
        
        let updated = selectedCourse
            .compactMap { $0 }
            .flatMapLatest { course -> Observable<Course> in
                set(course: course)
            }
        
        return Observable.merge(initial, updated)
    }
    
    func makeCourse() -> Driver<Course> {
        currentCourse
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
                SITestCloseMediator.shared.testClosed,
                ProfileMediator.shared.changedProfileLocale.map { _ in () }
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
                .obtainCourses()
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
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .asDriver(onErrorJustReturn: false)
            .startWith(SessionManager().hasActiveSubscriptions())
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
