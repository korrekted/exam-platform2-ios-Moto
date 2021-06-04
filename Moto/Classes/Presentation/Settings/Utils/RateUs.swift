//
//  RateUs.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 21.02.2021.
//

import StoreKit

final class RateUs {
    static func requestReview() {
        SKStoreReviewController.requestReview()
    }
}
