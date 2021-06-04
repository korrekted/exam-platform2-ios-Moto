//
//  SettingsViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    private lazy var coursesManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var profileManager = ProfileManagerCore()
    
    lazy var sections = makeSections()
}

// MARK: Private
private extension SettingsViewModel {
    func makeSections() -> Driver<[SettingsTableSection]> {
        let activeSubscription = self.activeSubscription()
        let profileLocale = getProfieLocale()
        let countries = getCountries()
        let course = getCourse()
        
        return Driver
            .combineLatest(activeSubscription, profileLocale, countries, course) { [weak self] activeSubscription, profileLocale, countries, course -> [SettingsTableSection] in
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
                
                if let settingsSection = self.makeSettingsSection(countries: countries) {
                    sections.append(settingsSection)
                }
                
                sections.append(.links)
                
                return sections
            }
    }
    
    func getProfieLocale() -> Driver<ProfileLocale?> {
        let initial = profileManager
            .obtainProfileLocale()
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .rxUpdatedProfileLocale
            .asDriver(onErrorDriveWith: .never())
            .map { locale -> ProfileLocale? in locale }
        
        return Driver.merge(initial, updated)
    }
    
    func getCountries() -> Driver<[Country]> {
        profileManager
            .retrieveCountries(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func activeSubscription() -> Driver<Bool> {
        let updated = SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .compactMap { $0?.activeSubscription }
            .asDriver(onErrorJustReturn: false)
        
        let initial = Driver<Bool>
            .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                let activeSubscription = this.sessionManager.getSession()?.activeSubscription ?? false
                
                return .just(activeSubscription)
            }
        
        return Driver
            .merge(initial, updated)
    }
    
    func getCourse() -> Driver<Course> {
        coursesManager
            .rxGetSelectedCourse()
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
