//
//  Country.swift
//  CDL
//
//  Created by Andrey Chernyshev on 25.05.2021.
//

struct Country: Codable, Hashable {
    let name: String
    let code: String
    let preSelected: Bool
    let sort: Int
    let languages: [Language]
}
