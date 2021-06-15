//
//  GetFlashcardsTopicsResponseMapper.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

final class GetFlashcardsTopicsResponseMapper {
    static func map(from response: Any) -> [FlashcardTopic] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let array = data["flashcard_sets"] as? [[String: Any]]
        else {
            return []
        }
        
        return array.compactMap { flashcardJSON -> FlashcardTopic? in
            guard
                let id = flashcardJSON["id"] as? Int,
                let name = flashcardJSON["name"] as? String,
                let paid = flashcardJSON["paid"] as? Bool,
                let imageUrl = flashcardJSON["img"] as? String,
                let count = flashcardJSON["count"] as? Int,
                let progress = flashcardJSON["progress"] as? Int
            else {
                return nil
            }

            return FlashcardTopic(id: id,
                                  name: name,
                                  paid: paid,
                                  imageUrl: imageUrl,
                                  count: count,
                                  progress: progress)
         }
    }
}
