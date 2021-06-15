//
//  GetFlashcardsResponseMapper.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

final class GetFlashcardsResponseMapper {
    static func map(from response: Any) -> [Flashcard] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let array = data["flashcards"] as? [[String: Any]]
        else {
            return []
        }
        
        return array.compactMap { flashcardJSON -> Flashcard? in
            guard
                let id = flashcardJSON["id"] as? Int,
                let front = flashcardJSON["front"] as? String,
                let back = flashcardJSON["back"] as? String,
                let knew = flashcardJSON["knew"] as? Bool
            else {
                return nil
            }
            
            let imageUrl = flashcardJSON["image"] as? String
            let videoUrl = flashcardJSON["video"] as? String
            
            return Flashcard(id: id,
                             image: imageUrl,
                             video: videoUrl,
                             front: front,
                             back: back,
                             knew: knew)
         }
    }
}
