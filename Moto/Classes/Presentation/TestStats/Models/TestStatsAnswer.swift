//
//  TestStatsAnswer.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Foundation

struct TestStatsAnswerElement {
    let question: String
    let isCorrect: Bool
}

extension TestStatsAnswerElement {
    init(answer: TestStatsAnswer) {
        question = answer.question
        isCorrect = answer.correct
    }
}
