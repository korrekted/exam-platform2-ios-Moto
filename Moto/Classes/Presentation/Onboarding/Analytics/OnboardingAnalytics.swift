//
//  OnboardingAnalytics.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.02.2021.
//

final class OnboardingAnalytics {
    func log(step: OnboardingView.Step) {
        let name: String
        
        switch step {
        case .started:
            name = "Welcome Screen"
        case .locale:
            name = "Locale Screen"
        case .goals:
            name = "Goals Screen"
        case .whenTaking:
            name = "When Exam Screen"
        case .time:
            name = "Test Time Screen"
        case .count:
            name = "Tests Number Screen"
        case .question1:
            name = "Question 1 Screen"
        case .question2:
            name = "Question 2 Screen"
        case .question3:
            name = "Question 3 Screen"
        case .question4:
            name = "Question 4 Screen"
        case .preloader:
            name = "Plan Preparing Screen"
        case .plan:
            name = "Personal Plan Screen"
        }
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: name, parameters: [:])
    }
}
