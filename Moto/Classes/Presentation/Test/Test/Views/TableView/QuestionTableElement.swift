//
//  QuestionTableElement.swift
//  CDL
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import Foundation

struct QuestionElement {
    let id: Int
    let elements: [TestingCellType]
    let isMultiple: Bool
    let index: Int
    var isAnswered: Bool
    let questionsCount: Int
    var isSaved: Bool
}

enum TestingCellType {
    case content([QuestionContentCollectionType])
    case question(String, html: String)
    case answers([PossibleAnswerElement])
    case result([AnswerResultElement])
    case explanationTitle
    case explanationText(String, html: String)
    case explanationImage(URL)
    case reference(String)
}

struct PossibleAnswerElement: Hashable {
    let id: Int
    let answer: String?
    let answerHtml: String?
    let image: URL?
}

struct AnswerResultElement {
    let answer: String?
    let answerHtml: String?
    let image: URL?
    let state: AnswerState
}

enum AnswerState {
    case initial, correct, warning, error
}

struct AnswerElement {
    let questionId: Int
    let answerIds: [Int]
    let isMultiple: Bool
}
