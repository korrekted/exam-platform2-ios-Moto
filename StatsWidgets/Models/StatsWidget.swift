//
//  StatsWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI
import WidgetKit

struct StatsContent: TimelineEntry {
    var date = Date()
    let passRate: CGFloat
    let testTaken: CGFloat
    let correctAnswers: CGFloat
    let questionsTaken: CGFloat
}

// MARK: Make
extension StatsContent {
    static var placeholder: StatsContent {
        StatsContent(passRate: 0,
                     testTaken: 0,
                     correctAnswers: 0,
                     questionsTaken: 0)
    }
}
