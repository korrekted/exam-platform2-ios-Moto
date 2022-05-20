//
//  PaygateManagerCore.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

protocol PaygateManagerProtocol: AnyObject {
    func retrievePaygate(forceUpdate: Bool) -> Single<PaygateMapper.PaygateResponse?>
    func prepareProductsPrices(for paygate: PaygateMapper.PaygateResponse) -> Single<PaygateMapper.PaygateResponse?>
}

final class PaygateManager: PaygateManagerProtocol {
    private let defaultRequestWrapper = DefaultRequestWrapper()
    
    private let iapManager = SDKStorage.shared.iapManager
}

// MARK: Retrieve
extension PaygateManager {
    func retrievePaygate(forceUpdate: Bool) -> Single<PaygateMapper.PaygateResponse?> {
        forceUpdate ? downloadAndCachePaygate() : cachedPaygate()
    }
    
    func prepareProductsPrices(for paygate: PaygateMapper.PaygateResponse) -> Single<PaygateMapper.PaygateResponse?> {
        guard !paygate.productsIds.isEmpty else {
            return .deferred { .just(paygate) }
        }
        
        return iapManager
            .obtainProducts(ids: paygate.productsIds)
            .map { products -> [ProductPrice] in
                products.map { ProductPrice(product: $0.product) }
            }
            .map { try PaygateMapper.parse(response: paygate.json, productsPrices: $0) }
    }
}

// MARK: Private
private extension PaygateManager {
    func downloadAndCachePaygate() -> Single<PaygateMapper.PaygateResponse?> {
        defaultRequestWrapper
            .callServerApi(requestBody: GetPaygateRequest(userToken: SessionManagerCore().getSession()?.userToken,
                                                          version: UIDevice.appVersion ?? "1"))
            .map { try PaygateMapper.parse(response: $0, productsPrices: nil) }
            .do(onSuccess: { data in
                PaygateStorage.shared.paygateResponse = data
            })
    }
    
    func cachedPaygate() -> Single<PaygateMapper.PaygateResponse?> {
        Single<PaygateMapper.PaygateResponse?>
            .create { event in
                let paygate = PaygateStorage.shared.paygateResponse
                
                event(.success(paygate))
                
                return Disposables.create()
            }
    }
}


// MARK: Private(PaygateStorage)
private final class PaygateStorage {
    static let shared = PaygateStorage()
    
    private init() {}
    
    var paygateResponse: PaygateMapper.PaygateResponse? {
        set(value) {
            _paygateResponse = value
        }
        get {
            _paygateResponse
        }
    }
    
    private var _paygateResponse: PaygateMapper.PaygateResponse?
}
