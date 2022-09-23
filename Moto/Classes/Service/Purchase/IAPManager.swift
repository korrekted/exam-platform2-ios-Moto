//
//  IAPManager.swift
//  DMV
//
//  Created by Андрей Чернышев on 28.07.2022.
//

import RxSwift
import SwiftyStoreKit
import StoreKit
import RushSDK

final class IAPManager {}

// MARK: Public
extension IAPManager {
    static func initialize() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                let state = purchase.transaction.transactionState
                if state == .purchased || state == .restored {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
        }
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { _, _ in
            true
        }
    }
    
    func obtainProducts(ids: [String]) -> Single<[IAPProduct]> {
        Single<[IAPProduct]>.create { event in
            SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { result in
                let products = result.retrievedProducts.map { IAPProduct(original: $0) }
                
                event(.success(products))
            }
            
            return Disposables.create()
        }
    }
    
    func buyProduct(with id: String) -> Single<IAPActionResult> {
        guard SwiftyStoreKit.canMakePayments else {
            return .error(IAPError(.paymentsDisabled))
        }

        return Single<IAPActionResult>
            .create { event in
                SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        if purchase.productId == id {
                            event(.success(.completed(id)))
                        }
                    case .error(let error):
                        if IAPErrorHelper.treatErrorAsCancellation(error) {
                            event(.success(.cancelled))
                        } else if IAPErrorHelper.treatErrorAsSuccess(error) {
                            event(.success(.completed(id)))
                        } else {
                            event(.failure(IAPError(.paymentFailed, underlyingError: error)))
                        }
                    }
                }

                return Disposables.create()
            }
    }
    
    func restorePurchases() -> Single<Void> {
        Single<Void>
            .create { event in
                SwiftyStoreKit.restorePurchases { result in
                    if result.restoredPurchases.isEmpty {
                        event(.failure(IAPError(.cannotRestorePurchases)))
                    } else {
                        event(.success(Void()))
                    }
                }

                return Disposables.create()
            }
    }
}
