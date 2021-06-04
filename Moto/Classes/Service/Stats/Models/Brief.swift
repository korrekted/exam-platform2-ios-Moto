//
//  Brief.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 15.02.2021.
//

struct Brief {
    let streak: Int
    let calendar: [Bool]
}

// MARK: Codable
extension Brief: Codable {}

// MARK: Hashable
extension Brief: Hashable {}
