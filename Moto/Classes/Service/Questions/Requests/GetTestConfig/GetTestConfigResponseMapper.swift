//
//  GetTestConfigResponseMapper.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 15.02.2021.
//

final class GetTestConfigResponseMapper {
    static func from(response: Any) -> CourseConfig? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let testsArray = data["tests"] as? [[String: Any]]
        else {
            return nil
        }
        
        let tests = testsArray
            .compactMap { testJSON -> TestConfig? in
                guard
                    let id = testJSON["id"] as? Int,
                    let paid = testJSON["paid"] as? Bool,
                    let count = testJSON["count"] as? Int,
                    let correctProgress = testJSON["correct_progress"] as? Int,
                    let incorrectProgress = testJSON["incorrect_progress"] as? Int
                else {
                    return nil
                }
                
                let name = testJSON["name"] as? String ?? ""
                
                return TestConfig(
                    id: id,
                    paid: paid,
                    name: name,
                    count: count,
                    correctProgress: correctProgress,
                    incorrectProgress: incorrectProgress
                )
            }
        
        let flashcardsJSON = data["flashcards"] as? [String: Any] ?? [:]
        let flashcardsCount = flashcardsJSON["count"] as? Int ?? 0
        let flashcardsCompleted = flashcardsJSON["completed"] as? Int ?? 0
        
        return CourseConfig(testsConfigs: tests,
                            flashcardsCount: flashcardsCount,
                            flashcardsCompleted: flashcardsCompleted)
    }
}
