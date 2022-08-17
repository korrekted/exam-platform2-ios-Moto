//
//  ProfileLocale.swift
//  CDL
//
//  Created by Andrey Chernyshev on 26.05.2021.
//

struct ProfileLocale: Codable, Hashable {
    let countryCode: String?
    let languageCode: String?
    let stateCode: String?
}
