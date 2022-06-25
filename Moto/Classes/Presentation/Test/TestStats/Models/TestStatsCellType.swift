//
//  TestStatsCellType.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import Foundation

enum TestStatsCellType {
    case progress(TestStatsProgressElement)
    case description(TestStatsDescriptionElement)
    case filter(TestStatsFilter)
    case answer(TestStatsAnswerElement)
    case comunityResult(TestStatsComunityResult)
}
