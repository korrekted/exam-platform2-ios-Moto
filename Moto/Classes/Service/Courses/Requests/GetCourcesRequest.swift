//
//  GetCoursesRequest.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import Alamofire

struct GetCourcesRequest: APIRequestBody {
    private let userToken: String
    
    init(userToken: String) {
        self.userToken = userToken
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/courses/list"
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
