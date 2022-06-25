//
//  SITestCloseMediator.swift
//  CDL
//
//  Created by Андрей Чернышев on 22.06.2022.
//

import RxSwift
import RxCocoa

final class SITestCloseMediator {
    static let shared = SITestCloseMediator()
    
    private let testClosedTrigger = PublishRelay<Void>()
    
    private init() {}
}

// MARK: Public
extension SITestCloseMediator {
    func notifyAboudTestClosed() {
        testClosedTrigger.accept(Void())
    }
}

// MARK: Triggers
extension SITestCloseMediator {
    var testClosed: Signal<Void> {
        testClosedTrigger.asSignal()
    }
}
