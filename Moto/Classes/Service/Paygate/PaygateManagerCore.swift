//
//  PaygateManagerCore.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class PaygateManagerCore: PaygateManager {}

// MARK: Retrieve
extension PaygateManagerCore {
    func retrievePaygate() -> Single<PaygateMapper.PaygateResponse?> {
        SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: GetPaygateRequest(userToken: SessionManagerCore().getSession()?.userToken,
                                                          version: UIDevice.appVersion ?? "1",
                                                          usedProducts: SessionManagerCore().getSession()?.usedProducts ?? []))
            .map { PaygateMapper.parse(response: $0, productsPrices: nil) }
    }
}

// MARK: Prepare prices
extension PaygateManagerCore {
    func prepareProductsPrices(for paygate: PaygateMapper.PaygateResponse) -> Single<PaygateMapper.PaygateResponse?> {
        guard !paygate.productsIds.isEmpty else {
            return .deferred { .just(paygate) }
        }
        
        return SDKStorage.shared
            .iapManager
            .obtainProducts(ids: paygate.productsIds)
            .map { products -> [ProductPrice] in
                products.map { ProductPrice(product: $0.product) }
            }
            .map { PaygateMapper.parse(response: paygate.json, productsPrices: $0) }
    }
}
