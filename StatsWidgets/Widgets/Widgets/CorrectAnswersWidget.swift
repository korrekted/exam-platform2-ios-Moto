//
//  CorrectAnswersWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct CorrectAnswersWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CorrectAnswersWidget", provider: Provider()) { entry in
            HStack {
                VerticalRateView(progress: entry.correctAnswers,
                                 title: "Stats.MainRate.CorrectAnswers".localized,
                                 color: Color(red: 255 / 255, green: 101 / 255, blue: 1 / 255),
                                 alignment: .leading)
                Spacer()
            }
            .padding(16.scale)
        }
        .supportedFamilies([.systemSmall])
    }
}
