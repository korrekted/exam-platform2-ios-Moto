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
            .flatMap { [weak self] stats -> Single<Stats?> in
                guard let self = self else {
                    return .never()
                }
                
                return self.write(stats: stats)
            }
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

// MARK: Private
private extension StatsManagerCore {
    func write(stats: Stats?) -> Single<Stats?> {
        Single<Stats?>
            .create { event in
                guard let stats = stats else {
                    event(.success(stats))
                    return Disposables.create()
                }
                
                StatsShareManager.shared.write(stats: stats)
                
                event(.success(stats))
                
                return Disposables.create()
            }
    }
}
