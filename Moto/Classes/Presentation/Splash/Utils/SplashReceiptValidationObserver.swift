//
//  SplashReceiptValidationObserver.swift
//  DMV
//
//  Created by Андрей Чернышев on 28.07.2022.
//

import OtterScaleiOS

final class SplashReceiptValidationObserver {
    private var defaultCompleted = false
    private var extractCompleted = false
    
    private var completion: (() -> Void)?
    
    private lazy var defaultValidationObserver = DefaultValidationObserver { [weak self] in
        guard let self = self else {
            return
        }
        
        self.defaultCompleted = true
        
        self.checkup()
    }
    
    private lazy var extractInternalUserID = ExtractInternalUserID { [weak self] in
        guard let self = self else {
            return
        }
        
        self.extractCompleted = true
        
        self.checkup()
    }
    
    func observe(completion: @escaping () -> Void) {
        self.completion = completion
        
        defaultValidationObserver.observe()
        extractInternalUserID.extract()
    }
    
    private func checkup() {
        guard defaultCompleted && extractCompleted else {
            return
        }
        
        completion?()
    }
}

private final class DefaultValidationObserver: OtterScaleReceiptValidationDelegate {
    private let completion: (() -> Void)
    
    init(completion: @escaping (() -> Void)) {
        self.completion = completion
    }
    
    func observe() {
        OtterScale.shared.add(delegate: self)
    }
    
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        OtterScale.shared.remove(delegate: self)
        
        completion()
    }
}

private final class ExtractInternalUserID: OtterScaleReceiptValidationDelegate {
    private let completion: (() -> Void)
    
    init(completion: @escaping (() -> Void)) {
        self.completion = completion
    }
    
    func extract() {
        guard NumberLaunches().isFirstLaunch() else {
            completion()
            return
        }
        
        BranchManager.shared.retrieveInternalUserID { [weak self] userID in
            guard let self = self else {
                return
            }
            
            guard let userID = userID else {
                self.completion()
                
                return
            }
            
            OtterScale.shared.add(delegate: self)
            
            OtterScale.shared.set(internalUserID: userID)
            
            self.sendIDToAnalytics(userID)
        }
    }
    
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        OtterScale.shared.remove(delegate: self)
        
        completion()
    }
    
    private func sendIDToAnalytics(_ userID: String) {
        AmplitudeManager.shared.set(userId: userID)
        AmplitudeManager.shared.logEvent(name: "User ID Set")
        
        FirebaseManager.shared.set(userId: userID)
        FirebaseManager.shared.logEvent(name: "client_user_id_set")
        
        FacebookManager.shared.set(userID: userID)
        FacebookManager.shared.logEvent(name: "client_user_id_set")
    }
}
