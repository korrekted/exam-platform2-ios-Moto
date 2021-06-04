//
//  GetStatsRequest.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 26.01.2021.
//

import Alamofire

struct GetStatsRequest: APIRequestBody {
    private let userToken: String
    private let courseId: Int
    
    init(userToken: String, courseId: Int) {
        self.userToken = userToken
        self.courseId = courseId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/stats/full"
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
