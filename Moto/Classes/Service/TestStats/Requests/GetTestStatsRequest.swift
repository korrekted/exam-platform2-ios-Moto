//
//  GetTestStatsRequest.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Alamofire

struct GetTestStatsRequest: APIRequestBody {
    private let userToken: String
    private let userTestId: Int
    
    init(userToken: String, userTestId: Int) {
        self.userToken = userToken
        self.userTestId = userTestId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/stats"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "user_test_id": userTestId,
        ]
    }
}
