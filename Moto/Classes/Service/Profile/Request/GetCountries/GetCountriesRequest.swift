//
//  GetCountriesRequest.swift
//  CDL
//
//  Created by Andrey Chernyshev on 25.05.2021.
//

import Alamofire

struct GetCountriesRequest: APIRequestBody {
    var url: String {
        GlobalDefinitions.domainUrl + "/api/courses/configuration"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey
        ]
    }
}
