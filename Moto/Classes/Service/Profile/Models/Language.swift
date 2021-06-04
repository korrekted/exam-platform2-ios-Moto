//
//  Language.swift
//  CDL
//
//  Created by Andrey Chernyshev on 24.04.2021.
//

struct Language {
    let name: String
    let code: String
    let preSelected: Bool
    let sort: Int
    let states: [State]
}

// MARK: Codable
extension Language: Codable {}

// MARK: Hashable
extension Language: Hashable {}
