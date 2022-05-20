//
//  SplashViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Step {
        case onboarding, course, paygate
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var validationComplete = PublishRelay<Void>()
    
    private lazy var monetizationManager = MonetizationManagerCore()
    private lazy var profileManager = ProfileManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var paygateManager = PaygateManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    func step() -> Driver<Step> {
        return validationComplete
            .flatMapLatest { [weak self] void -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                return self.library()
            }
            .compactMap { [weak self] void -> Step? in
                self?.makeStep()
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}

// MARK: Private
private extension SplashViewModel {
    func library() -> Observable<Void> {
        func source() -> Single<Void> {
            let monetization = monetizationManager
                .rxRetrieveMonetizationConfig(forceUpdate: true)
            
            let countries = profileManager
                .retrieveCountries(forceUpdate: true)
            
            let paygate = paygateManager
                .retrievePaygate(forceUpdate: true)
            
            return Single
                .zip(monetization, countries, paygate)
                .map { _ in Void() }
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
    }
    
    func makeStep() -> Step {
        guard OnboardingViewController.wasViewed() else {
            return .onboarding
        }
        
        return needPayment() ? .paygate : .course
    }
    
    func needPayment() -> Bool {
        let activeSubscription = sessionManager.getSession()?.activeSubscription ?? false
        return !activeSubscription
    }
}
