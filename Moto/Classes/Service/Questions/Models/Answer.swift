//
//  Answer.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

struct Answer: Codable, Hashable {
    let id: Int
    let answer: String?
    let answerHtml: String?
    let image: URL?
    let isCorrect: Bool
}
