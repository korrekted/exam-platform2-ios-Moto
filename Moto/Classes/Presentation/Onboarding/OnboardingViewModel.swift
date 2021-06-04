//
//  OnboardingViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    enum Step {
        case paygateBlock
        case paygateSuggest
        case nextScreen
    }
    
    private lazy var coursesManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var monetizationManager = MonetizationManagerCore()
    
    var hasSelectedCourse: Bool {
        coursesManager.getSelectedCourse() != nil
    }
    
    func whatNext() -> Step {
        let hasActiveSubscription = sessionManager.getSession()?.activeSubscription ?? false
        
        if hasActiveSubscription {
            return .nextScreen
        }
        
        guard let config = monetizationManager.getMonetizationConfig() else {
            return .nextScreen
        }
        
        switch config {
        case .block:
            return .paygateBlock
        case .suggest:
            return .paygateSuggest
        }
    }
}
