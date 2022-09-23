//
//  SplashViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa
import OtterScaleiOS

final class SplashViewModel {
    enum Step {
        case onboarding, course, paygate
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var validationComplete = PublishRelay<Void>()
    
    private lazy var monetizationManager = MonetizationManagerCore()
    private lazy var profileManager = ProfileManager()
    private lazy var sessionManager = SessionManager()
    private lazy var paygateManager = PaygateManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    func step() -> Driver<Step> {
        handleValidationComplete()
            .flatMapLatest { [weak self] void -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                return self.library()
            }
            .flatMap { [weak self] _ -> Single<Step> in
                guard let self = self else {
                    return .never()
                }
                
                return self.makeStep()
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}

// MARK: Private
private extension SplashViewModel {
    func handleValidationComplete() -> Observable<Void> {
        validationComplete.flatMapLatest { [weak self] _ -> Single<Void> in
            guard let self = self else {
                return .never()
            }
            
            let otterScaleID = OtterScale.shared.getInternalID()
            
            let complete: Single<Void>
            
            if let cachedToken = self.sessionManager.getSession()?.userToken {
                if cachedToken != otterScaleID {
                    complete = self.profileManager.syncTokens(oldToken: cachedToken, newToken: otterScaleID)
                } else {
                    complete = .deferred { .just(Void()) }
                }
            } else {
                complete = self.profileManager.login(userToken: otterScaleID)
            }
            
            return complete.flatMap { [weak self] _ -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                let session = Session(userToken: otterScaleID)
                self.sessionManager.store(session: session)
                
                return .deferred { .just(Void()) }
            }
        }
    }
    
    func library() -> Observable<Void> {
        func source() -> Single<Void> {
            let monetization = monetizationManager
                .rxRetrieveMonetizationConfig(forceUpdate: true)
            
            let countries = profileManager
                .obtainCountries(forceUpdate: true)
            
            let paygate = paygateManager
                .retrievePaygate(forceUpdate: true)
            
            let profile = profileManager
                .obtainProfile(forceUpdate: true)
            
            return Single
                .zip(monetization, countries, paygate, profile)
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
    
    func makeStep() -> Single<Step> {
        profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .map { [weak self] selectedCourse -> Step in
                guard let self = self else {
                    return .onboarding
                }
                
                if selectedCourse != nil {
                    return self.needPayment() ? .paygate : .course
                }
                
                if !OnboardingViewController.wasViewed() {
                    return .onboarding
                }
                
                return .course
            }
    }
    
    func needPayment() -> Bool {
        let activeSubscription = sessionManager.hasActiveSubscriptions()
        return !activeSubscription
    }
}
