//
//  StudyViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StudyViewModel {
    private lazy var courseManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var questionManager = QuestionManagerCore()
    private lazy var statsManager = StatsManagerCore()
    
    lazy var sections = makeSections()
    lazy var activeSubscription = makeActiveSubscription()
    lazy var course = makeCourseName()
    lazy var brief = makeBrief()
    
    let selectedCourse = BehaviorRelay<Course?>(value: nil)
    lazy var config = makeConfig().share(replay: 1, scope: .forever)
    
    private lazy var currentCourse = makeCurrentCourse().share(replay: 1, scope: .forever)
}

// MARK: Private
private extension StudyViewModel {
    
    func makeCurrentCourse() -> Observable<Course> {
        let saved = selectedCourse
            .compactMap { $0 }
        
        let defaultCourse = courseManager
            .retrieveCourses()
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
                
                result.append(flashcards)
                result.append(modes)
                
                return result
            }
    }
    
    func makeCoursesElements() -> Driver<StudyCollectionSection> {
        let courses = Signal
            .merge(
                QuestionManagerMediator.shared.rxTestPassed,
                QuestionManagerMediator.shared.rxTestClosed,
                ProfileMediator.shared.rxUpdatedProfileLocale.map { _ in () }
            )
            .asObservable()
            .startWith(())
            .flatMapLatest { [weak self] _ -> Single<[Course]> in
                guard let self = self else { return .never() }
                return self.courseManager
                    .retrieveCourses()
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
    
    func makeBrief() -> Driver<SCEBrief> {
        let testPassed = Signal
            .merge(
                QuestionManagerMediator.shared.rxTestPassed,
                QuestionManagerMediator.shared.rxTestClosed
            )
            .asObservable()
            .startWith(())
        
        return Observable.combineLatest(testPassed, currentCourse)
            .flatMapLatest { [weak self] _, course -> Single<(Course, Brief?)> in
                guard let this = self else {
                    return .never()
                }
                
                return this.statsManager
                    .retrieveBrief(courseId: course.id)
                    .map { (course, $0) }
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
    
    func makeFlashcards() -> Driver<StudyCollectionSection> {
        config
            .map { config -> StudyCollectionSection in
                let flashcards = SCEFlashcards(topicsToLearn: config.flashcardsCount,
                                               topicsLearned: config.flashcardsCompleted)
                
                return StudyCollectionSection(elements: [.flashcards(flashcards)])
            }
            .asDriver(onErrorDriveWith: .empty())
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
            .flatMapLatest { [manager = questionManager] course -> Observable<CourseConfig> in
                manager.retrieveConfig(courseId: course.id)
                    .asObservable()
                    .catchAndReturn(nil)
                    .compactMap { $0 }
            }
    }
}
