//
//  Profile.swift
//  CDL
//
//  Created by Андрей Чернышев on 16.08.2022.
//

struct Profile: Codable, Hashable {
    let selectedCoursesIds: [Int]
    let selectedCourse: Course?
    let locale: ProfileLocale?
    let testMode: TestMode?
}
