//
//  ProfileManager.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import RxSwift

protocol ProfileManager {
    // MARK: Counties
    func retrieveCountries(forceUpdate: Bool) -> Single<[Country]>
    
    // MARK: Profile locale
    func obtainProfileLocale() -> Single<ProfileLocale?>
    func set(country: String?,
             state: String?,
             language: String?) -> Single<Void>
    
    // MARK: Study
    func set(level: Int?,
             assetsPreferences: [Int]?,
             examDate: String?,
             testMinutes: Int?,
             testNumber: Int?,
             testWhen: [Int]?,
             notificationKey: String?) -> Single<Void>
    
    // MARK: Test Mode
    func set(testMode: Int) -> Single<Void>
    func obtainTestMode() -> Single<TestMode?>
}
