//
//  AnswerMapper.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

import Foundation

final class AnswerMapper {
    static func map(from answers: [[String: Any]]) -> [Answer] {
        answers.compactMap { answerJSON -> Answer? in
            AnswerMapper.map(from: answerJSON)
        }
    }
    
    static func map(from answerJSON: [String: Any]) -> Answer? {
        guard
            let id = answerJSON["id"] as? Int,
            let correct = answerJSON["correct"] as? Bool
        else {
            return nil
        }
        
        let answer = answerJSON["answer"] as? String
        let answerHtml = answerJSON["answer_html"] as? String
        
        let image = (answerJSON["image"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return Answer(id: id,
                      answer: answer,
                      answerHtml: answerHtml,
                      image: URL(string: image),
                      isCorrect: correct)
    }
}
