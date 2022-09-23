//
//  StatsViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StatsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var profileManager = ProfileManager()
    private lazy var statsManager = StatsManagerCore()
    private lazy var sessionManager = SessionManager()
    
    private lazy var progressRelay = BehaviorRelay<Int>(value: 0)
    private lazy var activeSubscription = makeActiveSubscription()
    
    lazy var courseName = makeCourseName()
    lazy var elements = makeElements()
    lazy var passRate = progressRelay.asDriver()
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension StatsViewModel {
    func makeCourseName() -> Driver<String> {
        profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .compactMap { $0?.name }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeElements() -> Driver<[StatsCellType]> {
        let elements = Signal
            .merge(
                QuestionMediator.shared.testPassed,
                TestCloseMediator.shared.testClosed.map { _ in Void() },
                SITestCloseMediator.shared.testClosed,
                ProfileMediator.shared.changedSelectedCourse.map { _ in Void() }
            )
            .asObservable()
            .startWith(())
            .flatMapLatest { [weak self] _ -> Observable<[StatsCellType]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[StatsCellType]> {
                    self.profileManager
                        .obtainSelectedCourse(forceUpdate: false)
                        .flatMap { selectedCourse -> Single<Stats?> in
                            guard let courseId = selectedCourse?.id else {
                                return .just(nil)
                            }
                            
                            return self.statsManager
                                .retrieveStats(courseId: courseId)
                        }
                        .map { [weak self] stats -> [StatsCellType] in
                            guard let stats = stats else { return [] }
                            self?.progressRelay.accept(stats.passRate)
                            let main: StatsCellType = .main(.init(stats: stats))
                            
                            return stats
                                .courseStats
                                .reduce(into: [main]) { $0.append(.course(.init(courseStats: $1))) }
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
            .asDriver(onErrorJustReturn: [])
        
        return Driver.combineLatest(elements, activeSubscription) { $1 ? $0 : $0 + [.needPayment] }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .asDriver(onErrorJustReturn: false)
            .startWith(SessionManager().hasActiveSubscriptions())
    }
}
