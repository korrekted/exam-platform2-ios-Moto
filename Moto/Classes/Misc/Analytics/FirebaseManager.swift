//
//  FirebaseManager.swift
//  DMV
//
//  Created by Андрей Чернышев on 28.07.2022.
//

import Firebase
import OtterScaleiOS
import StoreKit

final class FirebaseManager: NSObject {
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    static let shared = FirebaseManager()
    
    private override init() {
        super.init()
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension FirebaseManager: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        guard let otterScaleID = result?.externalUserID ?? result?.internalUserID else {
            return
        }
        
        guard otterScaleID != OtterScale.shared.getAnonymousID() else {
            return
        }
        
        set(userId: otterScaleID)
        
        logEvent(name: "client_user_id_synced")
    }
}

// MARK: SKPaymentTransactionObserver
extension FirebaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        let purchased = transactions
            .filter { $0.transactionState == .purchased }
        
        guard !purchased.isEmpty else {
            return
        }
        
        logEvent(name: "client_subscription_or_purchase")
    }
}

// MARK: Public
extension FirebaseManager {
    func initialize() {
        FirebaseApp.configure()
        
        OtterScale.shared.add(delegate: self)
        SKPaymentQueue.default().add(self)
        
        installFirstLaunchIfNeeded()
    }
    
    func set(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

// MARK: Private
private extension FirebaseManager {
    func installFirstLaunchIfNeeded() {
        guard NumberLaunches().isFirstLaunch() else {
            return
        }
        
        logEvent(name: "client_first_launch")
    }
}
