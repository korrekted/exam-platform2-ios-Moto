//
//  PaygateViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class PaygateViewModel {
    enum Config {
        case block, suggest
    }
    
    let buy = PublishRelay<String>()
    let restore = PublishRelay<String>()

    lazy var buyed = createBuyed()
    lazy var restored = createRestored()
    
    let buyProcessing = RxActivityIndicator()
    let restoreProcessing = RxActivityIndicator()
    let retrieveCompleted = BehaviorRelay<Bool>(value: false)
    
    private lazy var paygateManager = PaygateManagerCore()
    private lazy var purchaseInteractor = SDKStorage.shared.purchaseInteractor
    private lazy var monetizatiionManager = MonetizationManagerCore()
}

// MARK: Monetization
extension PaygateViewModel {
    func monetizationConfig() -> Driver<Config> {
        guard let conf = monetizatiionManager.getMonetizationConfig() else {
            return .deferred { .just(.suggest) }
        }
        
        switch conf {
        case .block:
            return .deferred { .just(.block) }
        case .suggest:
            return .deferred { .just(.suggest) }
        }
    }
}

// MARK: Get paygate content
extension PaygateViewModel {
    func retrieve() -> Driver<(Paygate?, Bool)> {
        let paygate = paygateManager
            .retrievePaygate()
            .asDriver(onErrorJustReturn: nil)
        
        let prices = paygate
            .flatMapLatest { [paygateManager] response -> Driver<PaygateMapper.PaygateResponse?> in
                guard let response = response else {
                    return .deferred { .just(nil) }
                }
                
                return paygateManager
                    .prepareProductsPrices(for: response)
                    .asDriver(onErrorJustReturn: nil)
            }
        
        return Driver
            .merge([paygate.map { ($0?.paygate, false) },
                    prices.map { ($0?.paygate, true) }])
            .do(onNext: { [weak self] stub in
                self?.retrieveCompleted.accept(stub.1)
            })
    }
}

// MARK: Make purchase
private extension PaygateViewModel {
    func createBuyed() -> Signal<Bool> {
        let purchase = buy
            .flatMapLatest { [purchaseInteractor, buyProcessing] productId -> Observable<Bool> in
                purchaseInteractor
                    .makeActiveSubscriptionByBuy(productId: productId)
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response != nil
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(buyProcessing)
                    .catchAndReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
    
    func createRestored() -> Signal<Bool> {
        let purchase = restore
            .flatMapLatest { [purchaseInteractor, restoreProcessing] productId -> Observable<Bool> in
                purchaseInteractor
                    .makeActiveSubscriptionByRestore()
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response != nil
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(restoreProcessing)
                    .catchAndReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
}
