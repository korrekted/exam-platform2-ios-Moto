//
//  FlashcardsViewModel.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import RxSwift
import RxCocoa

final class FlashcardsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var flashcardTopicId = BehaviorRelay<Int?>(value: nil)
    
    lazy var flashcards = makeFlashcards()
    lazy var mark = makeMark()
    
    lazy var selectedAnswer = PublishRelay<(id: Int, answer: Bool)>()
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var flashcardsManager = FlashcardsManagerCore()
}

// MARK: Private
private extension FlashcardsViewModel {
    func makeFlashcards() -> Driver<[FlashCardModel]> {
        flashcardTopicId.compactMap { $0 }
            .flatMapLatest { [weak self] flashcardTopicId -> Observable<[FlashCardModel]> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<[FlashCardModel]> {
                    self.flashcardsManager
                        .obtainFlashcards(flashcardTopicId: flashcardTopicId)
                        .map { elements in
                            elements.enumerated()
                                .map { index, element in
                                    let progress = "\(index + 1)/\(elements.count)"
                                    return FlashCardModel(model: element, progress: progress)
                                }
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeMark() -> Observable<Void> {
        selectedAnswer
            .flatMapFirst { [weak self] id, isKnew -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    self.flashcardsManager
                        .mark(flashcardId: id, know: isKnew)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
            }
    }
}
