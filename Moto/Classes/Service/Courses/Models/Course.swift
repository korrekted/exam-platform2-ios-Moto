//
//  Course.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

struct Course: Codable, Hashable {
    let id: Int
    let name: String
    let subTitle: String
    let isMain: Bool
    let sort: Int
    let progress: Int
    let testCount: Int
    let selected: Bool
}
