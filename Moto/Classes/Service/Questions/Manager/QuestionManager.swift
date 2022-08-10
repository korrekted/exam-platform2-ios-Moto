//
//  QuestionManagerCore.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import RxSwift

protocol QuestionManagerProtocol: AnyObject {
    func obtain(courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) -> Single<Test?>
    func obtainTenSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainFailedSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainQotd(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainRandomSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainSaved(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainIncorrect(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainAgainTest(userTestId: Int) -> Single<Test?>
    func finishTest(userTestId: Int) -> Single<Void>
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?>
    func saveQuestion(questionId: Int) -> Single<Void>
    func removeSavedQuestion(questionId: Int) -> Single<Void>
    func obtainConfig(courseId: Int) -> Single<CourseConfig?>
}

final class QuestionManager: QuestionManagerProtocol {
    private lazy var sessionManager = SessionManagerCore()
    
    private let defaultRequestWrapper = DefaultRequestWrapper()
    private let xorRequestWrapper = XORRequestWrapper()
}

extension QuestionManager {
    func obtain(courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTestRequest(
            userToken: userToken,
            courseId: courseId,
            testId: testId,
            time: time,
            activeSubscription: activeSubscription
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainTenSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTenSetRequest(userToken: userToken,
                                       courseId: courseId,
                                       activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainFailedSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetFailedSetRequest(userToken: userToken,
                                          courseId: courseId,
                                          activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainQotd(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetQotdRequest(userToken: userToken,
                                     courseId: courseId,
                                     activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainRandomSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetRandomSetRequest(userToken: userToken,
                                          courseId: courseId,
                                          activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainSaved(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSavedRequest(userToken: userToken,
                                      courseId: courseId,
                                      activeSubscription: activeSubscription)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: false) }
    }
    
    func obtainIncorrect(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetIncorrectRequest(userToken: userToken,
                                          courseId: courseId,
                                          activeSubscription: activeSubscription)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: false) }
    }
    
    func obtainAgainTest(userTestId: Int) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = AgainTestRequest(userToken: userToken,
                                       userTestId: userTestId)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func finishTest(userTestId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = FinishTestRequest(userToken: userToken,
                                        userTestId: userTestId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = SendAnswerRequest(
            userToken: userToken,
            questionId: questionId,
            userTestId: userTestId,
            answerIds: answerIds
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { SendAnswerResponseMapper.map(from: $0) }
            .do(onSuccess: { isEndOfTest in
                if isEndOfTest == true {
                    QuestionMediator.shared.notidyAboutTestPassed()
                }
            })
    }
    
    func saveQuestion(questionId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveQuestionRequest(userToken: userToken,
                                          questionId: questionId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func removeSavedQuestion(questionId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = RemoveSavedQuestionRequest(userToken: userToken,
                                                 questionId: questionId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func obtainConfig(courseId: Int) -> Single<CourseConfig?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetTestConfigRequest(userToken: userToken,
                                               courseId: courseId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map(GetTestConfigResponseMapper.from(response:))
    }
}
