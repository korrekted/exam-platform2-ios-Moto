//
//  GetTestResponseMapper.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

import Foundation

struct GetTestResponseMapper {
    static func map(from response: Any, isEncryption: Bool) throws -> Test? {
        isEncryption ? try encryptionMap(from: response) : try defaultMap(from: response)
    }
}

// MARK: Private
private extension GetTestResponseMapper {
    static func encryptionMap(from response: Any) throws -> Test? {
        guard
            let string = response as? String,
            let json = XOREncryption.toJSON(string, key: GlobalDefinitions.apiKey)
        else {
            return nil
        }
        
        return try map(json: json)
    }
    
    static func defaultMap(from response: Any) throws -> Test? {
        guard let json = response as? [String: Any] else {
            return nil
        }
        
        return try map(json: json)
    }
    
    static func map(json: [String: Any]) throws -> Test? {
        guard let code = json["_code"] as? Int else {
            return nil
        }
        
        guard code == 200 else {
            throw NSError(domain: "\(type(of: self))", code: code, userInfo: [NSLocalizedDescriptionKey : (json["_msg"] as? String) ?? ""])
        }
        
        guard
            let data = json["_data"] as? [String: Any],
            let timeLeft = data["time_left"] as? Int,
            let userTestId = data["user_test_id"] as? Int,
            let questionsJSON = data["questions"] as? [[String: Any]]
        else {
            return nil
        }
        
        let paid = data["paid"] as? Bool ?? false
        
        let questions = QuestionMapper.map(from: questionsJSON)
        
        guard !questions.isEmpty else { return nil }
        
        return Test(
            paid: paid,
            timeLeft: timeLeft,
            userTestId: userTestId,
            questions: questions
        )
    }
}
