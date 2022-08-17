//
//  GetProfileRequest.swift
//  CDL
//
//  Created by Андрей Чернышев on 16.08.2022.
//

import Alamofire

struct GetProfileRequest: APIRequestBody {
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
