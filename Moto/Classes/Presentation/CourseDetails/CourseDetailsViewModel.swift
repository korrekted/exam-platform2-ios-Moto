//
//  CourseDetailsViewModel.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 24.04.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class CourseDetailsViewModel {
    let course = BehaviorRelay<Course?>(value: nil)
    
    private lazy var questionManager = QuestionManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    
    lazy var passRate = course.asDriver().compactMap { $0?.progress }
    lazy var courseId = course.asDriver().compactMap { $0?.id }
    lazy var elements = makeElements()
    lazy var config = makeConfig().share(replay: 1, scope: .forever)
    
    lazy var activeSubscription = makeActiveSubscription().share(replay: 1, scope: .forever)
}

extension CourseDetailsViewModel {
    func makeElements() -> Driver<[CourseDetailsTableElement]> {
        Observable.combineLatest(activeSubscription, config)
            .map { activeSubscription, elements -> [CourseDetailsTableElement] in
                var result = elements.map { CourseDetailsTableElement.test(.init(config: $0)) }
                if !activeSubscription {
                    if result.count > 2 {
                        result.insert(.needPayment, at: 2)
                    } else {
                        result.append(.needPayment)
                    }
                }
                return result
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeConfig() -> Observable<[TestConfig]> {
        let config = courseId
            .asObservable()
            .flatMapLatest { [manager = questionManager] courseId -> Observable<[TestConfig]> in
                manager.retrieveConfig(courseId: courseId)
                    .asObservable()
                    .map { $0?.testsConfigs ?? [] }
                    .catchAndReturn([])
            }
        
        return Signal
            .merge(
                QuestionManagerMediator.shared.rxTestPassed,
                QuestionManagerMediator.shared.rxTestClosed
            )
            .asObservable()
            .startWith(())
            .flatMapLatest { _ in config }
    }
    
    func makeActiveSubscription() -> Observable<Bool> {
        let updated = SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .compactMap { $0?.activeSubscription }
            .asObservable()
            .catchAndReturn(false)
        
        let initial = Observable<Bool>
            .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                let activeSubscription = this.sessionManager.getSession()?.activeSubscription ?? false
                
                return .just(activeSubscription)
            }
        
        return Observable
            .merge(initial, updated)
    }
}
