//
//  TestStatsManagerCore.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import RxSwift

final class TestStatsManagerCore: TestStatsManager {
    private let defaultRequestWrapper = DefaultRequestWrapper()
}

extension TestStatsManagerCore {
    func retrieve(userTestId: Int) -> Single<TestStats?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTestStatsRequest(userToken: userToken, userTestId: userTestId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map(GetTestStatsResponseMapper.map(from:))
    }
}
