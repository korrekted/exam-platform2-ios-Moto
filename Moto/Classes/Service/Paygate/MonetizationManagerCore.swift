//
//  MonetizationManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

import RxSwift

final class MonetizationManagerCore: MonetizationManager {
    struct Constants {
        static let cachedMonetizationConfig = "monetization_manager_core_cached_monetization_config"
    }
}

// MARK: API
extension MonetizationManagerCore {
    func getMonetizationConfig() -> MonetizationConfig? {
        guard let rawValue = UserDefaults.standard.string(forKey: Constants.cachedMonetizationConfig) else {
            return nil
        }
        
        return MonetizationConfig(rawValue: rawValue)
    }
}

// MARK: API(Rx)
extension MonetizationManagerCore {
    func rxRetrieveMonetizationConfig(forceUpdate: Bool) -> Single<MonetizationConfig?> {
        if forceUpdate {
            return loadConfig()
        } else {
            return .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                return .just(this.getMonetizationConfig())
            }
        }
    }
}

// MARK: Private
private extension MonetizationManagerCore {
    func loadConfig() -> Single<MonetizationConfig?> {
        let request = GetMonetizationConfigRequest(userToken: SessionManagerCore().getSession()?.userToken,
                                                   version: UIDevice.appVersion ?? "1",
                                                   appAnonymousId: SDKStorage.shared.applicationAnonymousID)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map { GetMonetizationResponseMapper.map(from: $0) }
            .catchAndReturn(nil)
            .flatMap { [weak self] config -> Single<MonetizationConfig?> in
                guard let this = self else {
                    return .never()
                }
                
                return this.store(config: config)
            }
    }
    
    func store(config: MonetizationConfig?) -> Single<MonetizationConfig?> {
        Single<MonetizationConfig?>
            .create { event in
                guard let rawValue = config?.rawValue else {
                    event(.success(config))
                    return Disposables.create()
                }
        
                UserDefaults.standard.setValue(rawValue, forKey: Constants.cachedMonetizationConfig)
                
                event(.success(config))
                
                return Disposables.create()
            }
    }
}
