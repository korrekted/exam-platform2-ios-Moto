//
//  TestCloseMediator.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

import RxSwift
import RxCocoa

final class TestCloseMediator {
    static let shared = TestCloseMediator()
    
    private let testClosedTrigger = PublishRelay<TestFinishElement>()
    
    private init() {}
}

// MARK: Public
extension TestCloseMediator {
    func notifyAboudTestClosed(with element: TestFinishElement) {
        testClosedTrigger.accept(element)
    }
}

// MARK: Triggers
extension TestCloseMediator {
    var testClosed: Signal<TestFinishElement> {
        testClosedTrigger.asSignal()
    }
}
