//
//  SITest.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 08.04.2021.
//

import Foundation

struct SITest {
    let paid: Bool?
    let userTestId: Int
    let questions: [SIQuestion]
}

struct SIQuestion {
    let id: Int
    let image: URL?
    let video: URL?
    let question: String
    let questionHtml: String
    let answers: [SIAnswer]
    let multiple: Bool
    let explanation: String?
}

struct SIAnswer {
    let id: Int
    let answer: String
    let image: URL?
    let isCorrect: Bool
}
