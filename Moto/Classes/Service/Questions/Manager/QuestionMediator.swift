//
//  QuestionManagerMediator.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 27.02.2021.
//

import RxCocoa

protocol QuestionMediatorDelegate: AnyObject {
    func questionMediatorDidTestPassed()
}

final class QuestionMediator {
    static let shared = QuestionMediator()
    
    private let testPassedTrigger = PublishRelay<Void>()
    
    private var delegates = [Weak<QuestionMediatorDelegate>]()
    
    private init() {}
}

// MARK: Public
extension QuestionMediator {
    func notidyAboutTestPassed() {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.questionMediatorDidTestPassed()
            }
            
            self?.testPassedTrigger.accept(())
        }
    }
}

// MARK: Triggers(Rx)
extension QuestionMediator {
    var testPassed: Signal<Void> {
        testPassedTrigger.asSignal()
    }
}

// MARK: Observer
extension QuestionMediator {
    func add(delegate: QuestionMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<QuestionMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: QuestionMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
