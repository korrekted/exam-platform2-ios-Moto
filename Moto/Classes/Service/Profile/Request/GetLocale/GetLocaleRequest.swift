//
//  GetLocaleRequest.swift
//  CDL
//
//  Created by Andrey Chernyshev on 26.05.2021.
//

import Alamofire

struct GetLocaleRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/users/show"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
    }
}
