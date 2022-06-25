//
//  SaveQuestionRequest.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 07.04.2021.
//

import Alamofire

struct SaveQuestionRequest: APIRequestBody {
    private let userToken: String
    private let questionId: Int
    
    init(userToken: String, questionId: Int) {
        self.userToken = userToken
        self.questionId = questionId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/save"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "question_id": questionId
        ]
    }
}
