//
//  CoursesManager.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift

protocol CoursesManagerProtocol: AnyObject {
    func obtainCourses() -> Single<[Course]>
}

final class CoursesManager: CoursesManagerProtocol {
    private let defaultRequestWrapper = DefaultRequestWrapper()
}

// MARK: Public
extension CoursesManager {
    func obtainCourses() -> Single<[Course]> {
        guard let userToken = SessionManager().getSession()?.userToken else {
            return .deferred { .just([]) }
        }
        
        let request = GetCourcesRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetCourcesResponseMapper.map(from: $0) }
    }
}
