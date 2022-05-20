//
//  GetPaygateRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetPaygateRequest: APIRequestBody {
    private let userToken: String?
    private let version: String
    
    init(userToken: String?, version: String) {
        self.userToken = userToken
        self.version = version
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/payments/paygate"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "version": version,
            "anonymous_id": SDKStorage.shared.applicationAnonymousID
        ]
        
        if let userToken = userToken {
            params["_user_token"] = userToken
        }
        
        return params
    }
}
