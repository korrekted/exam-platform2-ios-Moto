//
//  SendAnswerRequest.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import Alamofire

struct SendAnswerRequest: APIRequestBody {
    private let userToken: String
    private let questionId: Int
    private let answerIds: [Int]
    private let userTestId: Int
    
    init(userToken: String, questionId: Int, userTestId: Int, answerIds: [Int]) {
        self.userToken = userToken
        self.questionId = questionId
        self.userTestId = userTestId
        self.answerIds = answerIds
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/answer"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "question_id": questionId,
            "user_test_id": userTestId,
            "answer_ids": answerIds
        ]
    }
}
