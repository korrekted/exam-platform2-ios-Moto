//
//  CoursesMediatorDelegate.swift
//  DMV
//
//  Created by Andrey Chernyshev on 28.06.2021.
//

protocol CoursesMediatorDelegate: AnyObject {
    func coursesMediatorDidChange(selectedCourse: Course)
}
