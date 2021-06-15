//
//  FlashcardsViewModel.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import RxSwift
import RxCocoa

final class FlashcardsViewModel {
    lazy var flashcardTopicId = BehaviorRelay<Int?>(value: nil)
    
    lazy var flashcards = makeFlashcards()
    lazy var mark = makeMark()
    
    lazy var selectedAnswer = PublishRelay<(id: Int, answer: Bool)>()
    
    private lazy var flashcardsManager = FlashcardsManagerCore()
}

// MARK: Private
private extension FlashcardsViewModel {
    func makeFlashcards() -> Driver<[FlashCardModel]> {
        flashcardTopicId.compactMap { $0 }
            .flatMapLatest { [weak self] flashcardTopicId -> Single<[FlashCardModel]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.flashcardsManager
                    .obtainFlashcards(flashcardTopicId: flashcardTopicId)
                    .map { elements in
                        elements.enumerated()
                            .map { index, element in
                                let progress = "\(index + 1)/\(elements.count)"
                                return FlashCardModel(model: element, progress: progress)
                            }
                    }
                    .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeMark() -> Observable<Void> {
        selectedAnswer
            .flatMapFirst { [flashcardsManager] id, isKnew -> Observable<Void> in
                flashcardsManager.mark(flashcardId: id, know: isKnew)
                    .asObservable()
                    .catchAndReturn(())
            }
    }
}
