//
//  FlashcardsManager.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import RxSwift

protocol FlashcardsManager: AnyObject {
    func obtainTopics(courseId: Int) -> Single<[FlashcardTopic]>
    func obtainFlashcards(flashcardTopicId: Int) -> Single<[Flashcard]>
    func mark(flashcardId: Int, know: Bool) -> Single<Void>
}
