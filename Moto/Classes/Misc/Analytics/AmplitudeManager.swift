//
//  AmplitudeManager.swift
//  DMV
//
//  Created by Андрей Чернышев on 28.07.2022.
//

import Amplitude_iOS
import OtterScaleiOS

final class AmplitudeManager {
    static let shared = AmplitudeManager()
    
    private init() {}
}

// MARK: OtterScaleReceiptValidationDelegate
extension AmplitudeManager: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        guard let otterScaleID = result?.externalUserID ?? result?.internalUserID else {
            return
        }
        
        guard otterScaleID != OtterScale.shared.getAnonymousID() else {
            return
        }
        
        set(userId: otterScaleID)
        
        logEvent(name: "User ID Synced")
    }
}

// MARK: Public
extension AmplitudeManager {
    func initialize() {
        Amplitude.instance().initializeApiKey(GlobalDefinitions.amplitudeApiKey)
        
        OtterScale.shared.add(delegate: self)
        
        installFirstLaunchIfNeeded()
    }
    
    func set(userId: String) {
        Amplitude.instance()?.setUserId(userId)
    }
    
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        var dictionary = parameters
        dictionary["anonymous_id"] = OtterScale.shared.getAnonymousID()
        dictionary["app"] = GlobalDefinitions.applicationTag
        
        Amplitude.instance()?.logEvent(name, withEventProperties: dictionary)
    }
}

// MARK: Private
private extension AmplitudeManager {
    func installFirstLaunchIfNeeded() {
        guard NumberLaunches().isFirstLaunch() else {
            return
        }
        
        logEvent(name: "First Launch")
    }
}
