//
//  Starter.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

@main
struct Starter: WidgetBundle {
    var body: some Widget {
        TestTakenWidget()
        CorrectAnswersWidget()
        QuestionsTakenWidget()
        MediumRateWidget()
        PassRateWidget()
    }
}
