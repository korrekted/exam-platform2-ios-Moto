//
//  FlashCardManagerMediator.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 12.06.2021.
//

import RxCocoa

final class FlashCardManagerMediator {
    static let shared = FlashCardManagerMediator()
    
    private let flashCardTrigger = PublishRelay<Void>()
    
    private var delegates = [Weak<FlashCardManagerDelegate>]()
    
    private init() {}
}

// MARK: API
extension FlashCardManagerMediator {
    func finishFlashCards() {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.didCardFinish()
            }
            
            self?.flashCardTrigger.accept(())
        }
    }
}

// MARK: Triggers(Rx)
extension FlashCardManagerMediator {
    var rxFlashCardFinished: Signal<Void> {
        flashCardTrigger.asSignal()
    }
}

// MARK: Observer
extension FlashCardManagerMediator {
    func add(delegate: QuestionManagerDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<FlashCardManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: FlashCardManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
