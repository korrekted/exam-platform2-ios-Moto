//
//  IAPError.swift
//  DMV
//
//  Created by Андрей Чернышев on 28.07.2022.
//

struct IAPError: Error {
    enum Code {
        case paymentsDisabled
        case paymentFailed
        case cannotRestorePurchases
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
