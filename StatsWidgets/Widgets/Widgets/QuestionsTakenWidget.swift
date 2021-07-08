//
//  QuestionsTakenWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct QuestionsTakenWidget: Widget {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "QuestionsTakenWidget", provider: Provider()) { entry in
            HStack {
                VerticalRateView(progress: entry.questionsTaken,
                                 title: "Stats.MainRate.QuestionsTaken".localized,
                                 color: Color(red: 1 / 255, green: 163 / 255, blue: 131 / 255),
                                 alignment: .leading)
                Spacer()
            }
            .padding(16.scale)
        }
        .supportedFamilies([.systemSmall])
    }
}
