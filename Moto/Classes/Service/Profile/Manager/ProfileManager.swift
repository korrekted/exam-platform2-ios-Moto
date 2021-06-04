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
}
