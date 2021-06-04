//
//  RateManagerCore.swift
//  Thermo
//
//  Created by Vitaliy Zagorodnov on 02.03.2021.
//

import Foundation
import StoreKit

final class RateManagerCore: RateManager {
    
}

// MARK: API
extension RateManagerCore {
    func showFirstAfterPassRateAlert() {
        let isFirstAfterPass = UserDefaults.standard.bool(forKey: Constants.showFirstAfterPass)
        
        guard !isFirstAfterPass else { return }
        
        SKStoreReviewController.requestReview()
        UserDefaults.standard.setValue(true, forKey: Constants.showFirstAfterPass)
    }
}

private extension RateManagerCore {
    enum Constants {
        static let showFirstAfterPass = "kFirstAfterPass"
    }
}
