//
//  MarkFlashcardRequest.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import Alamofire

struct MarkFlashcardRequest: APIRequestBody {
    let userToken: String
    let flashcardId: Int
    let know: Bool
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/flashcards/mark"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "flashcard_id": flashcardId,
            "know": know
        ]
    }
}
