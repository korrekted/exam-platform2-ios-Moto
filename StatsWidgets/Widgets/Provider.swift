//
//  Provider.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> StatsContent {
        return StatsContent.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (StatsContent) -> Void) {
        completion(StatsContent.placeholder)
    }

    func readContents() -> [Entry] {
        guard let stats = StatsShareManager.shared.read() else {
            return []
        }
    
        let content = StatsContent(passRate: CGFloat(stats.passRate) / 100,
                                   testTaken: CGFloat(stats.testTaken) / 100,
                                   correctAnswers: CGFloat(stats.correctAnswers) / 100,
                                   questionsTaken: CGFloat(stats.questionsTaken) / 100)
        return [content]
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StatsContent>) -> Void) {
        let entries = readContents()
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
