//
//  MainStatsElement.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 25.01.2021.
//

struct MainStatsElement {
    let passRate: Int
    let testTaken: Int
    let correctAnswers: Int
    let questionsTaken: Int
    let testsTakenNum: Int
    let longestStreak: Int
    let answeredQuestions: Int
    let correctAnswersNum: Int
}

// MARK: Initialize
extension MainStatsElement {
    init(stats: Stats) {
        passRate = stats.passRate
        testTaken = stats.testTaken
        correctAnswers = stats.correctAnswers
        questionsTaken = stats.questionsTaken
        testsTakenNum = stats.testsTakenNum
        longestStreak = stats.longestStreak
        answeredQuestions = stats.answeredQuestions
        correctAnswersNum = stats.correctAnswersNum
    }
}
