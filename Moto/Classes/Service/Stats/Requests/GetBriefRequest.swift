//
//  GetBriefRequest.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 15.02.2021.
//

import Alamofire

struct GetBriefRequest: APIRequestBody {
    private let userToken: String
    private let courseId: Int
    
    init(userToken: String, courseId: Int) {
        self.userToken = userToken
        self.courseId = courseId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/stats/brief"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId
        ]
    }
}
