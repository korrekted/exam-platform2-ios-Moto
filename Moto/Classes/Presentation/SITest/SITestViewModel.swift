//
//  SITestViewModel.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 07.04.2021.
//

import RxSwift
import RxCocoa

final class SITestViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    var activeSubscription = true

    let testType = BehaviorRelay<SITestType?>(value: nil)
    let courseId = BehaviorRelay<Int?>(value: nil)
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let didTapMark = PublishRelay<Bool>()
    let selectedIndex = BehaviorRelay<Int?>(value: nil)
    let selectedSIAnswers = BehaviorRelay<[SIAnswerElement]>(value: [])
    
    lazy var courseName = makeCourseName()
    lazy var question = makeQuestion()
    lazy var isEndOfTest = endOfTest()
    lazy var bottomViewState = makeBottomState()
    lazy var errorMessage = makeErrorMessage()
    lazy var needPayment = makeNeedPayment()
    lazy var isSavedQuestion = makeIsSavedQuestion()
    lazy var questionProgress = makeQuestionProgress()
    
    private lazy var questionManager = QuestionManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    
    private lazy var testElement = loadTest().share(replay: 1, scope: .forever)
    private lazy var selectedAnswers = makeSelectedAnswers().share(replay: 1, scope: .forever)
    
    private var notAnsweredQuestions = [SIQuestion]()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension SITestViewModel {
    func makeCourseName() -> Driver<String> {
        courseManager
            .rxGetSelectedCourse()
            .compactMap { $0?.name }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQuestion() -> Driver<SIQuestionElement> {
        var questionElements = [SIQuestionElement]()
        
        let questions = testElement
            .compactMap { $0.element?.questions }
            .map(questionElementMapper)
        
        let currentQuestion = Observable<Action>
            .merge(
                questions.map { .elements($0) },
                didTapNext.map { _ in .next },
                selectedIndex.compactMap { $0.map { .index($0) } }
            )
            .scan(nil) { old, action -> SIQuestionElement? in
                switch action {
                case .next:
                    let index = questionElements.firstIndex(where: { $0.id == old?.id }).map { $0 + 1 } ?? 0
                    return questionElements[safe: index] ?? questionElements.first
                case .index(let index):
                    return questionElements[safe: index - 1] ?? old
                case .elements(let elements):
                    questionElements = elements
                    return questionElements.first
                }
            }
            .compactMap { $0.map { TestAction.question($0) } }
        
        let selectedElements = selectedAnswers
                     .withLatestFrom(ProfileManagerCore().obtainTestMode()) { TestAction.answer($0, $1) }
        
        return Observable
            .merge(currentQuestion, selectedElements)
            .scan(nil, accumulator: answerQuestionAccumulator)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeSelectedAnswers() -> Observable<[SIAnswerElement]> {
        didTapConfirm
            .withLatestFrom(selectedSIAnswers)
            .startWith([])
    }
    
    func loadTest() -> Observable<Event<SITest>> {
        Observable.zip(courseId, testType)
            .flatMapLatest { [weak self] courseId, type -> Observable<Event<SITest>> in
                guard let self = self, let courseId = courseId, let type = type else { return .empty() }
                
                func source() -> Single<SITest> {
                    let test: Single<SITest?>
                    
                    switch type {
                    case .saved:
                        test = self.questionManager.retrieveSaved(courseId: courseId)
                    case .incorrect:
                        test = self.questionManager.retrieveIncorrect(courseId: courseId)
                    }
                    
                    return test.flatMap { test -> Single<SITest> in
                        guard let test = test else {
                            return .error(ContentError(.notContent))
                        }
                        
                        return .just(test)
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
                    .asObservable()
                    .do(onNext: { [weak self] in
                        self?.notAnsweredQuestions = $0.questions
                    })
                    .materialize()
                    .filter {
                        guard case .completed = $0 else { return true }
                        return false
                    }
            }
    }
    
    func makeErrorMessage() -> Signal<String> {
        testElement
            .compactMap { $0.error?.localizedDescription }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    func makeNeedPayment() -> Signal<Bool> {
        testElement
            .map { [weak self] event in
                guard let self = self, let element = event.element else { return false }
                return self.activeSubscription ? false : element.paid == false ? true : false
            }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    func endOfTest() -> Driver<Bool> {
        selectedAnswers
            .withLatestFrom(question) { ($0, $1) }
            .withLatestFrom(testElement) { ($0.0, $0.1, $1.element?.userTestId) }
            .flatMapLatest { [weak self] answers, question, userTestId -> Observable<Bool> in
                guard let self = self, let userTestId = userTestId else {
                    return .just(false)
                }
                
                func source() -> Single<Bool> {
                    self.questionManager
                        .sendAnswer(
                            questionId: question.id,
                            userTestId: userTestId,
                            answerIds: answers.map { $0.id }
                        )
                        .flatMap { result -> Single<Bool> in
                            guard let result = result else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(result)
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
                    .asObservable()
            }
            .map { [weak self] value in
                self?.notAnsweredQuestions.isEmpty == true ? true : value
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeBottomState() -> Driver<SIBottomButtonState> {
        Driver.combineLatest(isEndOfTest.startWith(false), question, selectedSIAnswers.asDriver(onErrorJustReturn: []))
            .map { isEndOfTest, question, answers -> SIBottomButtonState in
                return isEndOfTest ? .finish : answers.isEmpty ? .hidden : .confirm
            }
            .startWith(.hidden)
            .distinctUntilChanged()
    }
    
    func makeQuestionProgress() -> Driver<[SIProgressElement]> {
        question.map { question in
            var elements = [SIProgressElement]()
            
            for index in 1...question.questionsCount {
                elements.append(.init(index: index, isSelected: index == question.index))
            }
            return elements
        }
    }
    
    func makeIsSavedQuestion() -> Driver<Bool> {
        let isSavedQuestion = didTapMark
            .distinctUntilChanged()
            .withLatestFrom(question.map { $0.id }) { ($0, $1) }
            .flatMapFirst { [weak self] isSaved, questionId -> Observable<Bool> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Observable<Bool> {
                    let request = isSaved
                        ? self.questionManager.removeSavedQuestion(questionId: questionId)
                        : self.questionManager.saveQuestion(questionId: questionId)

                    return request
                        .andThen(Observable.just(!isSaved))
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }

                return source()
                    .retry { err in
                        err.flatMapLatest { error in
                            trigger(error: error)
                        }
                    }
            }
            .asDriver(onErrorJustReturn: false)
        
        let nextQuestion = didTapNext
            .map { _ in false }
            .asDriver(onErrorJustReturn: false)
        
        return Driver
            .merge(isSavedQuestion, nextQuestion)
            .startWith(true)
    }
}

// MARK: Additional
private extension SITestViewModel {
    enum Action {
        case next
        case index(Int)
        case elements([SIQuestionElement])
    }
    
    enum TestAction {
        case question(SIQuestionElement)
        case answer([SIAnswerElement], TestMode?)
    }
    
    var questionElementMapper: ([SIQuestion]) -> [SIQuestionElement] {
        return { questions in
            return questions.enumerated().map { index, question -> SIQuestionElement in
                let answers: [SITestCellType] = question.answers
                    .map { .answer(SIAnswerElement(id: $0.id, answer: $0.answer, image: $0.image, state: .initial, isCorrect: $0.isCorrect)) }
                
                let content: [QuestionContentType] = [
                    question.image.map { .image($0) },
                    question.video.map { .video($0) }
                ].compactMap { $0 }
                
                let elements: [SITestCellType] = [
                    !content.isEmpty ? .content(content) : nil,
                    .question(question.question, html: question.questionHtml)
                ].compactMap { $0 } + answers
                
                return SIQuestionElement(
                    id: question.id,
                    elements: elements,
                    isMultiple: question.multiple,
                    index: index + 1,
                    questionsCount: questions.count,
                    explanation: question.explanation,
                    isResult: false
                )
            }
        }
    }
    
    var answerQuestionAccumulator: (SIQuestionElement?, TestAction) -> SIQuestionElement? {
        return { [weak self] old, action -> SIQuestionElement? in
            switch action {
            case let .question(question):
                return question
            case let .answer(answers, testMode):
                guard let currentQuestion = old else { return old }
                self?.notAnsweredQuestions.removeAll(where: { $0.id == currentQuestion.id })
                let answerIds = answers.map { $0.id }
                let newElements = testMode == .onAnExam
                 ? currentQuestion.elements
                 : currentQuestion.elements
                     .map { element -> SITestCellType in
                         guard case var .answer(value) = element else { return element }

                         let state: AnswerState = answerIds.contains(value.id)
                             ? value.isCorrect ? .correct : .error
                             : value.isCorrect ? currentQuestion.isMultiple ? .warning : .correct : .initial

                         value.state = state

                         return .answer(value)
                     }
                
                let explanation: [SITestCellType] = [.none, .fullComplect].contains(testMode)
                    ? currentQuestion.explanation.map { [.explanation($0)] } ?? []
                    : []
                
                return SIQuestionElement(
                    id: currentQuestion.id,
                    elements: newElements + explanation,
                    isMultiple: currentQuestion.isMultiple,
                    index: currentQuestion.index,
                    questionsCount: currentQuestion.questionsCount,
                    explanation: currentQuestion.explanation,
                    isResult: true
                )
            }
        }
    }
}
