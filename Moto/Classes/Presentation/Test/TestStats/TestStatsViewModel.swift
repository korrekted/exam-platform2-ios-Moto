//
//  TestStatsViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import RxSwift
import RxCocoa

final class TestStatsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var userTestId = BehaviorRelay<Int?>(value: nil)
    lazy var testType = BehaviorRelay<TestType?>(value: nil)
    lazy var filterRelay = PublishRelay<TestStatsFilter>()
    lazy var tryAgainIsHidden = tryAgainIsHiddenRelay.asDriver()
        
    lazy var courseName = makeCourseName()
    lazy var elements = makeElements()
    lazy var testName = makeTestName()
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var testStatsManager = TestStatsManagerCore()
    private lazy var profileManager = ProfileManager()
    private lazy var tryAgainIsHiddenRelay = BehaviorRelay<Bool>(value: true)
    
    private lazy var stats = makeStats()
    
    var isTopicTest = false
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension TestStatsViewModel {
    func makeCourseName() -> Driver<String> {
        profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .compactMap { $0?.name }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeElements() -> Driver<[TestStatsCellType]> {
        return Driver
            .combineLatest(stats, filterRelay.asDriver(onErrorDriveWith: .never()))
            .map { [tryAgainIsHiddenRelay, isTopicTest] element, filter -> [TestStatsCellType] in
                guard let stats = element else { return [] }
                
                tryAgainIsHiddenRelay.accept(stats.passed)
                
                let main: [TestStatsCellType] = [
                    .progress(.init(stats: stats)),
                    .comunityResult(.init(stats: stats)),
                    .description(.init(stats: stats))
                ]
                
                guard !isTopicTest else {
                    return main
                }
                
                return stats.questions
                    .reduce(into: main + [.filter(filter)]) { old, question in
                        switch filter {
                        case .all:
                            old.append(.answer(.init(answer: question)))
                        case .incorrect:
                            if !question.correct {
                                old.append(.answer(.init(answer: question)))
                            } else {
                                break
                            }
                        case .correct:
                            if question.correct {
                                old.append(.answer(.init(answer: question)))
                            } else {
                                break
                            }
                        }
                    }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeStats() -> Driver<TestStats?> {
        userTestId
            .compactMap { $0 }
            .flatMapLatest { [weak self] userTestId -> Observable<TestStats?> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<TestStats?> {
                    self.testStatsManager
                        .retrieve(userTestId: userTestId)
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
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeTestName() -> Driver<String> {
        testType
            .map { $0?.name ?? "" }
            .asDriver(onErrorJustReturn: "")
    }
}
