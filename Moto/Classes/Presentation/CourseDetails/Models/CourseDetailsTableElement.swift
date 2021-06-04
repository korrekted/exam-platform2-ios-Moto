//
//  CourseDetailsTableElement.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 24.04.2021.
//

import Foundation

enum CourseDetailsTableElement {
    case test(CourseDetailsTestConfig)
    case needPayment
}

struct CourseDetailsTestConfig {
    let id: Int
    let name: String
    let correctProgress: Int
    let incorrectProgress: Int
    let questionCounts: Int
}

extension CourseDetailsTestConfig {
    init(config: TestConfig) {
        id = config.id
        correctProgress = config.correctProgress
        incorrectProgress = config.incorrectProgress
        questionCounts = config.count
        name = config.name
    }
}
