//
//  Flashcard.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

struct Flashcard {
    let id: Int
    let image: String?
    let video: String?
    let front: String
    let back: String
    let knew: Bool
}

// MARK: Codable
extension Flashcard: Codable {}


// MARK: Hashable
extension Flashcard: Hashable {}
