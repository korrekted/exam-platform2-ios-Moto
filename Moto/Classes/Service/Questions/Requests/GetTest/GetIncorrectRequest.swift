//
//  GetIncorrectRequest.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 07.04.2021.
//

import Alamofire

struct GetIncorrectRequest: APIRequestBody {
    let userToken: String
    let courseId: Int
    let activeSubscription: Bool
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/incorrect"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "user_is_premium": activeSubscription
        ]
    }
}
