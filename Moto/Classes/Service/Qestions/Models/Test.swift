//
//  Question.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import Foundation

struct Test {
    let paid: Bool
    let userTestId: Int
    let timeLeft: Int?
    let questions: [Question]
}

struct Question {
    let id: Int
    let image: URL?
    let video: URL?
    let question: String
    let questionHtml: String
    let answers: [Answer]
    let multiple: Bool
    let explanation: String?
    let isAnswered: Bool
}

struct Answer {
    let id: Int
    let answer: String
    let image: URL?
    let isCorrect: Bool
}
