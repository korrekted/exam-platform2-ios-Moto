//
//  QuestionMapper.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

import Foundation

final class QuestionMapper {
    static func map(from questions: [[String: Any]]) -> [Question] {
        questions.compactMap { questionJSON -> Question? in
            QuestionMapper.map(from: questionJSON)
        }
    }
    
    static func map(from questionJSON: [String: Any]) -> Question? {
        guard
            let id = questionJSON["id"] as? Int,
            let multiple = questionJSON["multiple"] as? Bool,
            let isAnswered = questionJSON["answered"] as? Bool,
            let answersJSON = questionJSON["answers"] as? [[String: Any]]
        else {
            return nil
        }
        
        let explanation = questionJSON["explanation"] as? String
        let explanationHtml = questionJSON["explanation_html"] as? String
        
        let answers: [Answer] = AnswerMapper.map(from: answersJSON)
        guard !answers.isEmpty else { return nil }
        
        let image = (questionJSON["image"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let video = (questionJSON["video"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let question = questionJSON["question"] as? String ?? ""
        let questionHtml = questionJSON["question_html"] as? String ?? ""
        
        let reference = questionJSON["reference"] as? String
        let media = questionJSON["explanation_media"] as? [String] ?? []
        let mediaURLs = media.compactMap { URL(string: $0)}
        
        let isSaved = questionJSON["saved"] as? Bool ?? false
        
        return Question(
            id: id,
            image: URL(string: image),
            video: URL(string: video),
            question: question,
            questionHtml: questionHtml,
            answers: answers,
            multiple: multiple,
            explanation: explanation,
            explanationHtml: explanationHtml,
            media: mediaURLs,
            isAnswered: isAnswered,
            reference: reference,
            isSaved: isSaved
        )
    }
}
