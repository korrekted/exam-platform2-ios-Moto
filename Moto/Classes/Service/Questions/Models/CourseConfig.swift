//
//  CourseConfig.swift
//  Moto
//
//  Created by Andrey Chernyshev on 15.06.2021.
//

struct CourseConfig {
    let testsConfigs: [TestConfig]
    
    let flashcardsCount: Int
    let flashcardsCompleted: Int
}

// MARK: Codable
extension CourseConfig: Codable {}

// MARK: Hashable
extension CourseConfig: Hashable {}
