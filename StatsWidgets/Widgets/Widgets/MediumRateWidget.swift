//
//  MediumRateWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct MediumRateWidget: Widget {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "MediumRateWidget", provider: Provider()) { entry in
            HStack(alignment: .center) {
                VerticalRateView(progress: entry.testTaken,
                                 title: "Stats.MainRate.TestsTake".localized,
                                 color: colorScheme == .dark
                                    ? Color.white
                                    : Color(red: 31 / 255, green: 31 / 255, blue: 31 / 255))
                Spacer()
                VerticalRateView(progress: entry.correctAnswers,
                                 title: "Stats.MainRate.CorrectAnswers".localized,
                                 color: Color(red: 255 / 255, green: 101 / 255, blue: 1 / 255))
                Spacer()
                VerticalRateView(progress: entry.questionsTaken,
                                 title: "Stats.MainRate.QuestionsTaken".localized,
                                 color: Color(red: 1 / 255, green: 163 / 255, blue: 131 / 255))
            }
            .padding(16)
        }
        .supportedFamilies([.systemMedium])
    }
}
