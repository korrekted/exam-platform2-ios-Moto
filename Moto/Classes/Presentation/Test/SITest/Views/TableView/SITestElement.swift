//
//  SITestElement.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 10.04.2021.
//

import Foundation

struct SIQuestionElement {
    let id: Int
    let elements: [SITestCellType]
    let isMultiple: Bool
    let index: Int
    let questionsCount: Int
    let explanation: String?
    let isResult: Bool
}

struct SIAnswerElement {
    let id: Int
    let answer: String
    let image: URL?
    var state: AnswerState
    let isCorrect: Bool
}

enum SITestCellType {
    case content([QuestionContentCollectionType])
    case question(String, html: String)
    case answer(SIAnswerElement)
    case explanation(String)
}
