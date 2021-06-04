//
//  FinishTestRequest.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 30.03.2021.
//

import Alamofire

struct FinishTestRequest: APIRequestBody {
    private let userToken: String
    private let userTestId: Int
    
    init(userToken: String, userTestId: Int) {
        self.userToken = userToken
        self.userTestId = userTestId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/finish"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "user_test_id": userTestId
        ]
    }
}
