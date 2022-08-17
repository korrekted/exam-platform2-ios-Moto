//
//  ProfileMediator.swift
//  CDL
//
//  Created by Andrey Chernyshev on 14.05.2021.
//

import RxSwift
import RxCocoa

protocol ProfileMediatorDelegate: AnyObject {
    func profileMediatorDidChanged(selectedCourse: Course)
    func profileMediatorDidChanged(selectedCoursesIds: [Int])
    func profileMediatorDidChanged(profileLocale: ProfileLocale)
    func profileMediatorDidChanged(testMode: TestMode)
}

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private var delegates = [Weak<ProfileMediatorDelegate>]()
    
    private lazy var selectedCourseTrigger = PublishRelay<Course>()
    private lazy var selectedCoursesIdsTrigger = PublishRelay<[Int]>()
    private lazy var profileLocaleTrigger = PublishRelay<ProfileLocale>()
    private lazy var testModeTrigger = PublishRelay<TestMode>()
    
    private init() {}
}

// MARK: Public
extension ProfileMediator {
    func notifyAboutChange(selectedCourse: Course) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.profileMediatorDidChanged(selectedCourse: selectedCourse)
            }
            
            self?.selectedCourseTrigger.accept(selectedCourse)
        }
    }
    
    func notifyAboutChange(coursesIds: [Int]) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.profileMediatorDidChanged(selectedCoursesIds: coursesIds)
            }
            
            self?.selectedCoursesIdsTrigger.accept(coursesIds)
        }
    }
    
    func notifyAboutChange(profileLocale: ProfileLocale) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.profileMediatorDidChanged(profileLocale: profileLocale)
            }
            
            self?.profileLocaleTrigger.accept(profileLocale)
        }
    }
    
    func notifyAboutChange(testMode: TestMode) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.profileMediatorDidChanged(testMode: testMode)
            }
            
            self?.testModeTrigger.accept(testMode)
        }
    }
}

// MARK: Triggers(Rx)
extension ProfileMediator {
    var changedSelectedCourse: Signal<Course> {
        selectedCourseTrigger.asSignal()
    }
    
    var changedSelectedCoursesIds: Signal<[Int]> {
        selectedCoursesIdsTrigger.asSignal()
    }
    
    var changedProfileLocale: Signal<ProfileLocale> {
        profileLocaleTrigger.asSignal()
    }
    
    var changedTestMode: Signal<TestMode> {
        testModeTrigger.asSignal()
    }
}

// MARK: Observer
extension ProfileMediator {
    func add(delegate: ProfileMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<ProfileMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: ProfileMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
