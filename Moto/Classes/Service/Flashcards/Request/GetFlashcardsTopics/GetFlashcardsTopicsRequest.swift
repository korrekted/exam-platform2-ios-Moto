//
//  GetFlashcardsTopicsRequest.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import Alamofire

struct GetFlashcardsTopicsRequest: APIRequestBody {
    let userToken: String
    let courseId: Int
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/flashcards/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId
        ]
    }
}
