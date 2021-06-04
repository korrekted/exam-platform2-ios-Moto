//
//  SITestCellType.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 10.04.2021.
//

import Foundation

enum SITestCellType {
    case content([QuestionContentType])
    case question(String, html: String)
    case answer(SIAnswerElement)
    case explanation(String)
}
