//
//  DefaultRequestWrapper.swift
//  ITExams
//
//  Created by Андрей Чернышев on 22.03.2022.
//

import RxSwift
import Alamofire

final class DefaultRequestWrapper {
    func callServerApi(requestBody: APIRequestBody) -> Single<Any> {
        execute(request: requestBody)
    }
}

// MARK: Private
private extension DefaultRequestWrapper {
    func execute(request: APIRequestBody, attempt: Int = 1, maxCount: Int = 3) -> Single<Any> {
        guard attempt <= maxCount else {
            return .deferred { .error(NSError(domain: "Request wrapper attempt limited", code: 404)) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: request)
            .catchAndReturn(["_code": 500])
            .flatMap { [weak self] response -> Single<Any> in
                guard let self = self else {
                    return .never()
                }
                
                let success = self.success(response: response)
                
                return success ? .just(response) : self.execute(request: request, attempt: attempt + 1)
            }
    }
    
    func success(response: Any) -> Bool {
        guard
            let json = response as? [String: Any],
            let code = json["_code"] as? Int
        else {
            return false
        }
        
        return code == 200
    }
}
