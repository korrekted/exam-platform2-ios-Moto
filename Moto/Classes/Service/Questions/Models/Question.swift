//
//  Question.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

struct Question: Codable, Hashable {
    let id: Int
    let image: URL?
    let video: URL?
    let question: String
    let questionHtml: String
    let answers: [Answer]
    let multiple: Bool
    let explanation: String?
    let explanationHtml: String?
    let media: [URL]
    let isAnswered: Bool
    let reference: String?
    let isSaved: Bool
}
