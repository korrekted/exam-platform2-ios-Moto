//
//  APIRequestBody.swift
//  ITExams
//
//  Created by Андрей Чернышев on 11.03.2022.
//

import Alamofire

protocol APIRequestBody {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    var cookies: [HTTPCookie] { get }
}

// MARK: Default
extension APIRequestBody {
    var url: String {
        ""
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        nil
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var cookies: [HTTPCookie] {
        []
    }
}
