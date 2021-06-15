//
//  FlashcardsViewModel.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import RxSwift
import RxCocoa

final class FlashcardsTopicsViewModel {
    lazy var courseId = BehaviorRelay<Int?>(value: nil)
    
    lazy var flashcardsTopics = makeFlashcardsTopics()
    lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var flashcardsManager = FlashcardsManagerCore()
    private lazy var sessionManager = SessionManagerCore()
}

// MARK: Private
private extension FlashcardsTopicsViewModel {
    func makeFlashcardsTopics() -> Driver<[FlashcardTopic]> {
        FlashCardManagerMediator.shared.rxFlashCardFinished
            .asObservable()
            .startWith(())
            .withLatestFrom(courseId.compactMap { $0 })
            .flatMapLatest { [weak self] courseId -> Single<[FlashcardTopic]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.flashcardsManager
                    .obtainTopics(courseId: courseId)
                    .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
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
}
