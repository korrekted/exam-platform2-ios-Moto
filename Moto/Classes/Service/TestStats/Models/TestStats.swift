//
//  TestStats.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Foundation

struct TestStats {
    let correctNumbers: Int
    let incorrectNumbers: Int
    let userTime: String
    let userScore: Int
    let communityTime: String
    let communityScore: Int
    let passed: Bool
    let passingScore: Int
    let questions: [TestStatsAnswer]
}

struct TestStatsAnswer {
    let question: String
    let correct: Bool
}
