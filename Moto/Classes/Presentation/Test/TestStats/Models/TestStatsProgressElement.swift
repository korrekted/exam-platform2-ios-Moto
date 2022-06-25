//
//  TestStatsProgressElement.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Foundation

struct TestStatsProgressElement {
    let percent: Int
    let passingScore: Int
}

extension TestStatsProgressElement {
    init(stats: TestStats) {
        percent = stats.userScore
        passingScore = stats.passingScore
    }
}
