//
//  TestType.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 13.02.2021.
//

import Foundation

enum TestType {
    case get(testId: Int?)
    case tenSet
    case failedSet
    case qotd
    case randomSet
    case timedQuizz(minutes: Int)
}

extension TestType {
    var name: String {
        switch self {
        case .get:
            return "Study.TakeTest".localized
        case .tenSet:
            return "Study.Mode.TenQuestions".localized
        case .failedSet:
            return "Study.Mode.MissedQuestions".localized
        case .qotd:
            return "Study.Mode.TodaysQuestion".localized
        case .randomSet:
            return "Study.Mode.RandomSet".localized
        case .timedQuizz:
            return "Study.Mode.TimedQuizz".localized
        }
    }
    
    var title: String {
        switch self {
        case .get:
            return "Study.TakeTest".localized
        case .tenSet:
            return "Question.Title.TenQuestions".localized
        case .failedSet:
            return "Question.Title.MissedQuestions".localized
        case .qotd:
            return "Question.Title.TodaysQuestion".localized
        case .randomSet:
            return "Question.Title.RandomSet".localized
        case .timedQuizz:
            return "Question.Title.TimedQuizz".localized
        }
    }
}
