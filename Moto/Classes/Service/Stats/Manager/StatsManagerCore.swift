//
//  StatsManagerCore.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 26.01.2021.
//

import RxSwift

final class StatsManagerCore: StatsManager {}

// MARK: API(Rx)
extension StatsManagerCore {
    func retrieveStats(courseId: Int) -> Single<Stats?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetStatsRequest(userToken: userToken, courseId: courseId)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetStatsResponseMapper.map(from:))
    }
    
    func retrieveBrief(courseId: Int) -> Single<Brief?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetBriefRequest(userToken: userToken, courseId: courseId)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetBriefResponseMapper.from(response:))
    }
}
