//
//  TestStatsManager.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import RxSwift

protocol TestStatsManager {
    // MARK: API(Rx)
    func retrieve(userTestId: Int) -> Single<TestStats?>
}
