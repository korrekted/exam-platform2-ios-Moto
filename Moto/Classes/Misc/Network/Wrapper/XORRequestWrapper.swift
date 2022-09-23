//
//  XORRequestWrapper.swift
//  ITExams
//
//  Created by Андрей Чернышев on 22.03.2022.
//

import RxSwift
import Alamofire

final class XORRequestWrapper {
    func callServerStringApi(requestBody: APIRequestBody, key: String = GlobalDefinitions.apiKey) -> Single<Any> {
        execute(request: requestBody, key: key)
    }
}

// MARK: Private
private extension XORRequestWrapper {
    func execute(request: APIRequestBody, key: String, attempt: Int = 1, maxCount: Int = 3) -> Single<Any> {
        guard attempt <= maxCount else {
            return .deferred { .error(NSError(domain: "Request wrapper attempt limited", code: 404)) }
        }
        
        return RestAPITransport()
            .callServerStringApi(requestBody: request)
            .catchAndReturn("")
            .flatMap { [weak self] response -> Single<Any> in
                guard let self = self else {
                    return .never()
                }
                
                let success = self.success(response: response, key: key)
                
                return success ? .just(response) : self.execute(request: request, key: key, attempt: attempt + 1)
            }
    }
    
    func success(response: Any, key: String) -> Bool {
        guard
            let string = response as? String,
            let json = XOREncryption.toJSON(string, key: key),
            let code = json["_code"] as? Int
        else {
            return false
        }
        
        return code == 200
    }
}
