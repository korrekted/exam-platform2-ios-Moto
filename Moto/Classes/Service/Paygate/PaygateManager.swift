//
//  PaygateManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

protocol PaygateManager: class {
    func retrievePaygate() -> Single<PaygateMapper.PaygateResponse?>
    func prepareProductsPrices(for paygate: PaygateMapper.PaygateResponse) -> Single<PaygateMapper.PaygateResponse?>
}
