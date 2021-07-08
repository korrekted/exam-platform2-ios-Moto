//
//  TestTakenWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct TestTakenWidget: Widget {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TestTakenWidget", provider: Provider()) { entry in
            HStack {
                VerticalRateView(progress: entry.testTaken,
                                 title: "Stats.MainRate.TestsTake".localized,
                                 color: colorScheme == .dark
                                    ? Color.white
                                    : Color(red: 31 / 255, green: 31 / 255, blue: 31 / 255),
                                 alignment: .leading)
                Spacer()
            }
            .padding(16.scale)
        }
        .supportedFamilies([.systemSmall])
    }
}
