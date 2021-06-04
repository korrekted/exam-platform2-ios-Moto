//
//  Stats.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 26.01.2021.
//

import Foundation

struct Stats {
    let passRate: Int
    let testTaken: Int
    let correctAnswers: Int
    let questionsTaken: Int
    let testsTakenNum: Int
    let longestStreak: Int
    let answeredQuestions: Int
    let correctAnswersNum: Int
    let courseStats: [CourseStats]
    
    struct CourseStats: Codable {
        let id: Int
        let name: String
        let testsTaken: Int
        let correctAnswers: Int
        let questionsTaken: Int
    }
}

// MARK: Codable
extension Stats: Codable {}
