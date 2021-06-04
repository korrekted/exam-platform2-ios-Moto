//
//  GetTestRequest.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import Alamofire

struct GetTestRequest: APIRequestBody {
    private let userToken: String
    private let courseId: Int
    private let testId: Int?
    private let time: Int?
    private let activeSubscription: Bool
    
    init(userToken: String, courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) {
        self.userToken = userToken
        self.courseId = courseId
        self.testId = testId
        self.time = time
        self.activeSubscription = activeSubscription
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/get"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "user_is_premium": activeSubscription
        ]
        
        if let testId = testId {
            params["test_id"] = testId
        }
        
        if let time = time {
            params["test_lifetime"] = time
        }
        
        return params
    }
}
