//
//  TestStatsComunityResult.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 29.03.2021.
//

import Foundation

struct TestStatsComunityResult {
    let userTime: String
    let communityAverage: String
    let communityScore: String
}

extension TestStatsComunityResult {
    init(stats: TestStats) {
        userTime = stats.userTime
        communityAverage = stats.communityTime
        communityScore = "\(stats.communityScore)%"
    }
}
