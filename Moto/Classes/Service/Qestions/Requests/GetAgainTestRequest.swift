//
//  GetAgainTestRequest.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 05.04.2021.
//

import Alamofire

struct GetAgainTestRequest: APIRequestBody {
    private let userToken: String
    private let testId: Int
    private let courseId: Int
    private let activeSubscription: Bool
    
    init(userToken: String, courseId: Int, testId: Int, activeSubscription: Bool) {
        self.userToken = userToken
        self.testId = testId
        self.activeSubscription = activeSubscription
        self.courseId = courseId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/testings/random_set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "user_test_id": testId,
            "course_id": courseId,
            "user_is_premium": activeSubscription
        ]
    }
}

