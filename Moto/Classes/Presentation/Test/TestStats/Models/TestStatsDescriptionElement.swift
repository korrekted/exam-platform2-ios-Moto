//
//  TestStatsDescriptionElement.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Foundation

struct TestStatsDescriptionElement {
    let attempted: Int?
    let correctNumber: Int
    let incorrectNumber: Int
}

extension TestStatsDescriptionElement {
    init(stats: TestStats) {
        attempted = nil
        correctNumber = stats.correctNumbers
        incorrectNumber = stats.incorrectNumbers
    }
}
