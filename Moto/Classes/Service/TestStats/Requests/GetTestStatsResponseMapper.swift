//
//  GetTestStatsResponseMapper.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Foundation

struct GetTestStatsResponseMapper {
    static func map(from response: Any) -> TestStats? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let stats = data["stats"] as? [String: Any],
            let correctNumber = stats["correct_number"] as? Int,
            let incorrectNumber = stats["incorrect_number"] as? Int,
            let userTime = stats["user_time"] as? String,
            let userScore = stats["user_score"] as? Int,
            let communityTime = stats["community_time"] as? String,
            let communityScore = stats["community_score"] as? Int,
            let passed = stats["passed"] as? Bool,
            let passingScore = stats["pass_threshold"] as? Int,
            let questions = stats["questions"] as? [[String: Any]]
        else {
            return nil
        }
        
        let elements = questions
            .compactMap { questionJSON -> TestStatsAnswer? in
                guard
                    let question = questionJSON["question"] as? String,
                    let correst = questionJSON["correct"] as? Bool
                else {
                    return nil
                }
                
                return TestStatsAnswer(question: question, correct: correst)
            }
        
        return TestStats(
            correctNumbers: correctNumber,
            incorrectNumbers: incorrectNumber,
            userTime: userTime,
            userScore: userScore,
            communityTime: communityTime,
            communityScore: communityScore,
            passed: passed,
            passingScore: passingScore,
            questions: elements
        )
    }
}
