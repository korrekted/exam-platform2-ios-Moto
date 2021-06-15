//
//  GetFlashcardsRequest.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import Alamofire

struct GetFlashcardsRequest: APIRequestBody {
    let userToken: String
    let flashcardTopicId: Int
    let activeSubscription: Bool
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/flashcards/get"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "flashcard_set_id": flashcardTopicId,
            "user_is_premium": activeSubscription
        ]
    }
}
