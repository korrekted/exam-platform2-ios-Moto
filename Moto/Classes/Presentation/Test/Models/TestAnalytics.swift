//
//  TestAnalytics.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.02.2021.
//

final class TestAnalytics {
    static func name(mode: TestType) -> String {
        switch mode {
        case .failedSet:
            return "missed questions"
        case .get:
            return "get"
        case .qotd:
            return "question of the day"
        case .randomSet:
            return "random set"
        case .tenSet:
            return "10 questions"
        case .timedQuizz:
            return ""
        }
    }
}
