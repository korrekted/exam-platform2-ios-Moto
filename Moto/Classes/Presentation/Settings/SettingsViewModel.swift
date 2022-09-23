//
//  SettingsViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var coursesManager = CoursesManager()
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager = ProfileManager()
    
    lazy var sections = makeSections()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension SettingsViewModel {
    func makeSections() -> Driver<[SettingsTableSection]> {
        let activeSubscription = self.activeSubscription()
        let profileLocale = getProfieLocale()
        let testMode = getTestMode()
        let countries = getCountries()
        let course = getCourse()
        
        return Driver
            .combineLatest(activeSubscription, profileLocale, testMode, countries, course) { [weak self] activeSubscription, profileLocale, testMode, countries, course -> [SettingsTableSection] in
                guard let self = self else {
                    return []
                }
                
                var sections = [SettingsTableSection]()
                
                if let localeSection = self.makeLocaleSection(locale: profileLocale, countries: countries) {
                    sections.append(localeSection)
                }
                
                if !activeSubscription {
                    sections.append(.unlockPremium)
                }
                
                if let testMode = testMode {
                    sections.append(.mode(testMode))
                }
                
                if let settingsSection = self.makeSettingsSection(countries: countries) {
                    sections.append(settingsSection)
                }
                
                sections.append(.links)
                
                return sections
            }
    }
    
    func getProfieLocale() -> Driver<ProfileLocale?> {
        func source() -> Single<ProfileLocale?> {
            profileManager
                .obtainLocale(forceUpdate: false)
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        let initial = observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedProfileLocale
            .asDriver(onErrorDriveWith: .never())
            .map { locale -> ProfileLocale? in locale }
        
        return Driver.merge(initial, updated)
    }
    
    func getTestMode() -> Driver<TestMode?> {
        func source() -> Single<TestMode?> {
            profileManager
                .obtainTestMode(forceUpdate: false)
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        let initial = observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedTestMode
            .asDriver(onErrorDriveWith: .never())
            .map { locale -> TestMode? in locale }
        
        return Driver.merge(initial, updated)
    }
    
    func getCountries() -> Driver<[Country]> {
        profileManager
            .obtainCountries(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func activeSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .asDriver(onErrorJustReturn: false)
            .startWith(SessionManager().hasActiveSubscriptions())
    }
    
    func getCourse() -> Driver<Course> {
        profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeSettingsSection(countries: [Country]) -> SettingsTableSection? {
        if countries.isEmpty {
            return nil
        }
        
        if countries.count > 1 {
            return .settings([.locale])
        }
        
        // если одна страна
        
        let languages = countries.first?.languages ?? []
        
        if languages.isEmpty {
            return nil
        }
        
        if languages.count > 1 {
            return .settings([.locale])
        }
        
        // если одна страна с одним языком
        
        let states = languages.first?.states ?? []
        
        if states.isEmpty || states.count == 1 {
            return nil
        }
        
        return .settings([.locale])
    }
    
    func makeLocaleSection(locale: ProfileLocale?, countries: [Country]) -> SettingsTableSection? {
        guard let locale = locale else {
            return nil
        }
        
        guard
            let countryCode = locale.countryCode,
            let country = countries.first(where: { $0.code == countryCode })
        else  {
            return nil
        }
        
        guard
            let languageCode = locale.languageCode,
            let language = country.languages.first(where: { $0.code == languageCode })
        else {
            let countryRow = ("Settings.YourLocale".localized, country.name)
            return .locale([countryRow])
        }
        
        guard
            let stateCode = locale.stateCode,
            let state = language.states.first(where: { $0.code == stateCode })
        else {
            let countryRow = ("Settings.YourLocale".localized, country.name)
            let languageRow = ("Settings.YourLanguage".localized, language.name)
            return .locale([countryRow, languageRow])
        }
        
        let countryRow = ("Settings.YourLocale".localized, [country.name, state.name].joined(separator: ", "))
        let languageRow = ("Settings.YourLanguage".localized, language.name)
        return .locale([countryRow, languageRow])
    }
}
