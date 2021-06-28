//
//  CoursesMediator.swift
//  DMV
//
//  Created by Andrey Chernyshev on 28.06.2021.
//

import RxCocoa

final class CoursesMediator {
    static let shared = CoursesMediator()
    
    private let changedSelectedCourseTrigger = PublishRelay<Course>()
    
    private var delegates = [Weak<CoursesMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension CoursesMediator {
    func notifyAbout(selectedCourse: Course) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.coursesMediatorDidChange(selectedCourse: selectedCourse)
            }
            
            self?.changedSelectedCourseTrigger.accept((selectedCourse))
        }
    }
}

// MARK: Triggers(Rx)
extension CoursesMediator {
    var rxChangedSelectedCourse: Signal<Course> {
        changedSelectedCourseTrigger.asSignal()
    }
}

// MARK: Observer
extension CoursesMediator {
    func add(delegate: CoursesMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<CoursesMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: CoursesMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}

