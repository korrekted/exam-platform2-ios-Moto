//
//  ContentError.swift
//  Moto
//
//  Created by Андрей Чернышев on 20.05.2022.
//

struct ContentError: Error {
    public enum Code {
        case notContent
    }

    public let code: Code
    public let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
