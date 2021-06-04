//
//  GetStatsResponseMapper.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 26.01.2021.
//

struct GetStatsResponseMapper {
    static func map(from response: Any) -> Stats? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let main = data["main"] as? [String: Any]
        else {
            return nil
        }
        
        let courseStats = map(from: data["rest"] as? [[String: Any]] ?? [])
        
        guard
            let passRate = main["pass_rate"] as? Int,
            let testTaken = main["tests_taken"] as? Int,
            let correctAnswers = main["correct_answers"] as? Int,
            let questionsTaken = main["questions_taken"] as? Int,
            let testsTakenNum = main["tests_taken_num"] as? Int,
            let longestStreak = main["longest_streak"] as? Int,
            let answeredQuestions = main["answered_questions"] as? Int,
            let correctAnswersNum = main["correct_answers_num"] as? Int
        else {
            return nil
        }

        return Stats(
            passRate: passRate,
            testTaken: testTaken,
            correctAnswers: correctAnswers,
            questionsTaken: questionsTaken,
            testsTakenNum: testsTakenNum,
            longestStreak: longestStreak,
            answeredQuestions: answeredQuestions,
            correctAnswersNum: correctAnswersNum,
            courseStats: courseStats
        )
    }
}

// MARK: Private
private extension GetStatsResponseMapper {
    static func map(from courseStats: [[String: Any]]) -> [Stats.CourseStats] {
        courseStats
            .compactMap { restJSON -> Stats.CourseStats? in
                guard
                    let id = restJSON["course_id"] as? Int,
                    let name = restJSON["name"] as? String,
                    let testsTaken = restJSON["tests_taken"] as? Int,
                    let correctAnswers = restJSON["correct_answers"] as? Int,
                    let questionsTaken = restJSON["questions_taken"] as? Int
                else {
                    return nil
                }
                
                return .init(
                    id: id,
                    name: name,
                    testsTaken: testsTaken,
                    correctAnswers: correctAnswers,
                    questionsTaken: questionsTaken
                )
            }
    }
}
