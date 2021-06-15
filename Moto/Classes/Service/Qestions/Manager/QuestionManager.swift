//
//  QuestionManager.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import RxSwift

protocol QuestionManager: AnyObject {
    // MARK: API(Rx)
    func retrieve(courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) -> Single<Test?>
    func retrieveTenSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func retrieveFailedSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func retrieveQotd(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func retrieveRandomSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?>
    func retrieveConfig(courseId: Int) -> Single<CourseConfig?>
    func finishTest(userTestId: Int) -> Completable
    func againTest(courseId: Int, testId: Int, activeSubscription: Bool) -> Single<Test?>
    func saveQuestion(questionId: Int) -> Completable
    func removeSavedQuestion(questionId: Int) -> Completable
    func retrieveSaved(courseId: Int) -> Single<SITest?>
    func retrieveIncorrect(courseId: Int) -> Single<SITest?>
}
