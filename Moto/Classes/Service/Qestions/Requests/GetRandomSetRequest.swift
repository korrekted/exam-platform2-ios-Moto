//
//  GetRandomSetRequest.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import Alamofire

struct GetRandomSetRequest: APIRequestBody {
    private let userToken: String
    private let courseId: Int
    private let activeSubscription: Bool
    
    init(userToken: String, courseId: Int, activeSubscription: Bool) {
        self.userToken = userToken
        self.courseId = courseId
        self.activeSubscription = activeSubscription
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/random_set"
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
