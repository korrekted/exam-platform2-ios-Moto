//
//  SplashSDKInitialize.swift
//  DMV
//
//  Created by Андрей Чернышев on 19.05.2022.
//

final class SplashSDKInitialize {
    enum Progress {
        case error, initializing, complete
    }
    
    private lazy var validationObserver = SplashReceiptValidationObserver()
}

// MARK: Public
extension SplashSDKInitialize {
    func initialize(handler: @escaping ((Progress) -> Void)) {
        handler(.initializing)
        
        validationObserver.observe {
            handler(.complete)
        }
    }
}
