//
//  FlashcardsManagerCore.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import RxSwift

final class FlashcardsManagerCore: FlashcardsManager {
    private let defaultRequestWrapper = DefaultRequestWrapper()
}

// MARK: Public
extension FlashcardsManagerCore {
    func obtainTopics(courseId: Int) -> Single<[FlashcardTopic]> {
        guard let userToken = SessionManager().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetFlashcardsTopicsRequest(userToken: userToken,
                                                 courseId: courseId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map(GetFlashcardsTopicsResponseMapper.map(from:))
    }
    
    func obtainFlashcards(flashcardTopicId: Int) -> Single<[Flashcard]> {
        guard let userToken = SessionManager().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetFlashcardsRequest(userToken: userToken,
                                           flashcardTopicId: flashcardTopicId,
                                           activeSubscription: SessionManager().hasActiveSubscriptions())
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map(GetFlashcardsResponseMapper.map(from:))
    }
    
    func mark(flashcardId: Int, know: Bool) -> Single<Void> {
        guard let userToken = SessionManager().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = MarkFlashcardRequest(userToken: userToken,
                                           flashcardId: flashcardId,
                                           know: know)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { _ in Void() }
    }
}
