//
//  ProfileMediatorDelegate.swift
//  CDL
//
//  Created by Andrey Chernyshev on 14.05.2021.
//

protocol ProfileMediatorDelegate: AnyObject {
    func didUpdated(profileLocale: ProfileLocale)
    func didUpdated(testMode: TestMode)
}
