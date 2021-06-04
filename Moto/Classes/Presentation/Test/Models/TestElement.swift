//
//  TestElement.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import Foundation

struct AnswerElement {
    let id: Int
    let answer: String
    let image: URL?
    var state: AnswerState
    let isCorrect: Bool
}

enum AnswerState {
    case initial, correct, warning, error
}


struct QuestionElement {
    let id: Int
    let elements: [TestingCellType]
    let isMultiple: Bool
    let index: Int
    let isAnswered: Bool
    let questionsCount: Int
    let explanation: String?
    let isResult: Bool
}
