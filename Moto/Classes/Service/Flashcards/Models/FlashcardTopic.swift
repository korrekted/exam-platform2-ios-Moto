//
//  Flashcard.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

struct FlashcardTopic {
    let id: Int
    let name: String
    let paid: Bool
    let imageUrl: String
    let count: Int
    let progress: Int
}

// MARK: Codable
extension FlashcardTopic: Codable {}


// MARK: Hashable
extension FlashcardTopic: Hashable {}
