//
//  TestConfig.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 15.02.2021.
//

struct TestConfig {
    let id: Int
    let paid: Bool
    let name: String
    let count: Int
    let correctProgress: Int
    let incorrectProgress: Int
}

// MARK: Codable
extension TestConfig: Codable {}

// MARK: Hashable
extension TestConfig: Hashable {}
