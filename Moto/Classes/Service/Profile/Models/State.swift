//
//  State.swift
//  CDL
//
//  Created by Andrey Chernyshev on 24.04.2021.
//

struct State {
    let name: String
    let code: String
    let sort: Int
}

// MARK: Codable
extension State: Codable {}

// MARK: Hashable
extension State: Hashable {}
