//
//  StatsManager.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 26.01.2021.
//

import RxSwift

protocol StatsManager: AnyObject {
    // MARK: API(Rx)
    func retrieveStats(courseId: Int) -> Single<Stats?>
    func retrieveBrief(courseId: Int) -> Single<Brief?>
}
