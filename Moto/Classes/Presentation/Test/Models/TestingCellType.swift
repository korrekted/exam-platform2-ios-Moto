//
//  TestingCellType.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import Foundation

enum TestingCellType {
    case content([QuestionContentType])
    case question(String, html: String)
    case answer(AnswerElement)
    case explanation(String)
}
