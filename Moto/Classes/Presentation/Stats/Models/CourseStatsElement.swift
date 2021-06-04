//
//  CourseStatsElement.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 25.01.2021.
//

struct CourseStatsElement {
    let id: Int
    let name: String
    let testsTaken: Int
    let correctAnswers: Int
    let questionsTaken: Int
}

// MARK: Initialize
extension CourseStatsElement {
    init(courseStats: Stats.CourseStats) {
        id = courseStats.id
        name = courseStats.name
        testsTaken = courseStats.testsTaken
        correctAnswers = courseStats.correctAnswers
        questionsTaken = courseStats.questionsTaken
    }
}
