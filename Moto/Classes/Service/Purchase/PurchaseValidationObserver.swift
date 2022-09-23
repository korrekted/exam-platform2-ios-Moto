//
//  PurchaseValidationObserver.swift
//  DMV
//
//  Created by Андрей Чернышев on 28.07.2022.
//

import OtterScaleiOS
import RxSwift
import RxCocoa

final class PurchaseValidationObserver {
    static let shared = PurchaseValidationObserver()
    
    private lazy var trigger = PublishRelay<Void>()
    
    private init() {}
    
    func startObserve() {
        OtterScale.shared.add(delegate: self)
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension PurchaseValidationObserver: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        trigger.accept(Void())
    }
}

// MARK: Public
extension PurchaseValidationObserver {
    var didValidatedWithActiveSubscription: Signal<Void> {
        trigger.asSignal()
    }
}
