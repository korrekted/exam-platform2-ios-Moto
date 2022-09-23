//
//  BranchManager.swift
//  DMV
//
//  Created by Андрей Чернышев on 28.07.2022.
//

import Branch
import StoreKit

final class BranchManager: NSObject {
    static let shared = BranchManager()
    
    private let installRefParams = InstallRefParams()
    
    private override init() {}
}

// MARK: Public
extension BranchManager {
    func initialize(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Branch.getInstance().initSession(launchOptions: launchOptions)
        
        SKPaymentQueue.default().add(self)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        Branch.getInstance().application(app, open: url, options: options)
    }
    
    func application(continue userActivity: NSUserActivity) {
        Branch.getInstance().continue(userActivity)
    }
    
    func retrieveInternalUserID(completion: @escaping ((String?) -> Void)) {
        installRefParams.retrieveInternalUserID(completion: completion)
    }
}

// MARK: SKPaymentTransactionObserver
extension BranchManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        BranchEvent(name: "CLIENT_SUBSCRIBE_OR_PURCHASE")
            .logEvent()
    }
}

private final class InstallRefParams {
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    private var timer: Timer?
    
    private var tick = 0
    
    func retrieveInternalUserID(completion: @escaping ((String?) -> Void)) {
        timer?.invalidate()
        tick = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            let params = Branch.getInstance().getFirstReferringParams()
            let userID = params?["internal_user_id"] as? String
            
            if userID != nil || self.tick > 4 {
                self.timer?.invalidate()
                self.timer = nil
                
                completion(userID)
                
                return
            }
            
            self.tick += 1
        }
    }
}
