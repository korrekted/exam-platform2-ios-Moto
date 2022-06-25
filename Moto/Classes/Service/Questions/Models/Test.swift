//
//  Question.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import Foundation

struct Test: Codable, Hashable {
    let paid: Bool
    let timeLeft: Int?
    let userTestId: Int
    let questions: [Question]
}
