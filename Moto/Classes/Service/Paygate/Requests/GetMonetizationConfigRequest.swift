//
//  GetMonetizationConfigRequest.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

import Alamofire

struct GetMonetizationConfigRequest: APIRequestBody {
    private let userToken: String?
    private let version: String
    private let appAnonymousId: String
    
    init(userToken: String? = nil,
         version: String,
         appAnonymousId: String) {
        self.userToken = userToken
        self.version = version
        self.appAnonymousId = appAnonymousId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/monetization"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "_api_key": GlobalDefinitions.apiKey,
            "anonymous_id": appAnonymousId,
            "version": version
        ]
        
        if let userToken = self.userToken {
            params["_user_token"] = userToken
        }
        
        return params
    }
}
