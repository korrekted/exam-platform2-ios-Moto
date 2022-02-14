//
//  RestApiTransportExtension.swift
//  Moto
//
//  Created by Андрей Чернышев on 14.02.2022.
//

import Alamofire
import RxSwift

extension RestAPITransport {
    func callServerStringApi(requestBody: APIRequestBody) -> Single<String> {
        Single.create { single in
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 30
            
            let encodedUrl = requestBody.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let request = manager.request(encodedUrl,
                                          method: requestBody.method,
                                          parameters: requestBody.parameters,
                                          encoding: requestBody.encoding,
                                          headers: requestBody.headers)
                .responseString(completionHandler: { response in
                    switch response.result {
                    case .success(let json):
                        single(.success(json))
                    case .failure(let error):
                        single(.failure(error))
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
