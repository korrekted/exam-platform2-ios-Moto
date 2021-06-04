//
//  GetSavedAndIncorrectResponseMapper.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 08.04.2021.
//

import Foundation

struct GetSavedAndIncorrectResponseMapper {
    static func map(from response: Any) throws -> SITest? {
        guard
            let json = response as? [String: Any],
            let code = json["_code"] as? Int
        else { return nil }
        
        guard code == 200 else {
            throw NSError(domain: "\(type(of: self))", code: code, userInfo: [NSLocalizedDescriptionKey : (json["_msg"] as? String) ?? ""])
        }
        
        guard
            let data = json["_data"] as? [String: Any],
            let paid = data["paid"] as? Bool,
            let userTestId = data["user_test_id"] as? Int,
            let questionsJSON = data["questions"] as? [[String: Any]]
        else {
            return nil
        }
        
        let questions: [SIQuestion] = Self.map(from: questionsJSON)
        
        guard !questions.isEmpty else { return nil }
        
        return SITest(
            paid: paid,
            userTestId: userTestId,
            questions: questions
        )
    }
}

// MARK: Private
private extension GetSavedAndIncorrectResponseMapper {
    static func map(from questions: [[String: Any]]) -> [SIQuestion] {
        questions.compactMap { restJSON -> SIQuestion? in
            guard
                let id = restJSON["id"] as? Int,
                let question = restJSON["question"] as? String,
                let multiple = restJSON["multiple"] as? Bool,
                let answersJSON = restJSON["answers"] as? [[String: Any]]
            else {
                return nil
            }
            
            let explanation = restJSON["explanation"] as? String
            let answers: [SIAnswer] = Self.map(from: answersJSON)
            guard !answers.isEmpty else { return nil }
            
            let image = (restJSON["image"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let video = (restJSON["video"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            let questionHtml = restJSON["question_html"] as? String ?? ""
            
            return SIQuestion(
                id: id,
                image: URL(string: image),
                video: URL(string: video),
                question: question,
                questionHtml: questionHtml,
                answers: answers,
                multiple: multiple,
                explanation: explanation
            )
        }
    }
    
    static func map(from answers: [[String: Any]]) -> [SIAnswer] {
        answers.compactMap { restJSON -> SIAnswer? in
            guard
                let id = restJSON["id"] as? Int,
                let answer = restJSON["answer"] as? String,
                let correct = restJSON["correct"] as? Bool
            else {
                return nil
            }
            
            let image = (restJSON["image"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            return SIAnswer(
                id: id,
                answer: answer,
                image: URL(string: image),
                isCorrect: correct
            )
        }
    }
}
