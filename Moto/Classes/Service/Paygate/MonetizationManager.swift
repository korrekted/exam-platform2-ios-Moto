//
//  MonetizationManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

import RxSwift

protocol MonetizationManager: AnyObject {
    // MARK: API
    func getMonetizationConfig() -> MonetizationConfig?
    
    // MARK: API(Rx)
    func rxRetrieveMonetizationConfig(forceUpdate: Bool) -> Single<MonetizationConfig?>
}
