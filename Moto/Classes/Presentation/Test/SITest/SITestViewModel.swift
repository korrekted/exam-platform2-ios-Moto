//
//  SITestViewModel.swift
//  CDL
//
//  Created by Андрей Чернышев on 23.06.2022.
//

import RxSwift
import RxCocoa
import RushSDK

final class SITestViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    let didTapMark = PublishRelay<Bool>()
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let didTapIndexQuestion = PublishRelay<Int>()
    let answers = BehaviorRelay<AnswerElement?>(value: nil)
    
    lazy var courseName = makeCourseName()
    lazy var questionProgress = makeQuestionProgress()
    lazy var isSavedQuestion = makeIsSavedQuestion()
    lazy var questions = makeQuestions()
    lazy var question = makeQuestion()
    lazy var isEndOfTest = endOfTest()
    lazy var userTestId = makeUserTestId()
    lazy var bottomViewState = makeBottomState()
    lazy var testMode = makeTestMode()
    
    lazy var loadTestActivityIndicator = RxActivityIndicator()
    lazy var sendAnswerActivityIndicator = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var testElement = loadTest()
    private lazy var selectedAnswers = makeSelectedAnswers()
    private lazy var currentAnswers = makeCurrentAnswers()
    
    private let course: BehaviorRelay<Course>
    private let testType: BehaviorRelay<SITestType>
    
    private lazy var questionManager = QuestionManager()
    private lazy var profileManager = ProfileManager()
    private lazy var sessionManager = SessionManager()
    
    private let answeredQuestionId = PublishRelay<Int>()
    
    init(course: Course, testType: SITestType) {
        self.course = BehaviorRelay(value: course)
        self.testType = BehaviorRelay(value: testType)
    }
}

// MARK: Private
private extension SITestViewModel {
    func makeCourseName() -> Driver<String> {
        course
            .asDriver()
            .map { $0.name }
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
        let initial = question
            .asObservable()
            .map { $0.isSaved }
        
        let isSavedQuestion = didTapMark
            .withLatestFrom(question) { ($0, $1.id) }
            .flatMapFirst { [weak self] isSaved, questionId -> Observable<Bool> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Bool> {
                    let request = isSaved
                        ? self.questionManager.removeSavedQuestion(questionId: questionId)
                        : self.questionManager.saveQuestion(questionId: questionId)

                    return request
                        .map { !isSaved }
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
        
        return Observable
            .merge(initial, isSavedQuestion)
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeQuestion() -> Driver<QuestionElement> {
        Observable<Action>
            .merge(
                self.didTapNext.debounce(.microseconds(500), scheduler: MainScheduler.instance).map { .continue },
                self.didTapIndexQuestion.map { .index($0) },
                self.questions.map { .elements($0) }
            )
            .scan((nil, []), accumulator: currentQuestionAccumulator)
            .compactMap { $0.0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQuestions() -> Observable<[QuestionElement]> {
        let questions = testElement
            .compactMap { $0.questions }
            .asObservable()
            .share(replay: 1)

        let mode = testMode.asObservable()
        
        return questions
            .flatMapLatest { [weak self] questions -> Observable<[QuestionElement]> in
                guard let self = self else {
                    return .never()
                }
                
                let elements = Observable
                    .combineLatest(self.selectedAnswers, mode) {
                        QuestionAction.elements(questions, $0, $1)
                    }
                let answered = self.answeredQuestionId
                    .map { QuestionAction.answered(questionId: $0)}
                
                return Observable
                    .merge(elements, answered)
                    .scan([], accumulator: self.questionAccumulator)
            }
    }
    
    func makeSelectedAnswers() -> Observable<AnswerElement?> {
        didTapConfirm
            .withLatestFrom(currentAnswers)
            .startWith(nil)
    }
    
    func loadTest() -> Driver<Test> {
        let courseId = course
            .map { $0.id }
            .asDriver(onErrorDriveWith: .never())
        
        let type = testType
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .combineLatest(courseId, type)
            .flatMapLatest { [weak self] courseId, type -> Driver<Test> in
                guard let self = self else {
                    return .empty()
                }
                
                let activeSubscription = self.sessionManager.hasActiveSubscriptions()
                
                func source() -> Single<Test> {
                    let test: Single<Test?>
                    switch type {
                    case .saved:
                        test = self.questionManager
                            .obtainSaved(courseId: courseId, activeSubscription: activeSubscription)
                    case .incorrect:
                        test = self.questionManager
                            .obtainIncorrect(courseId: courseId, activeSubscription: activeSubscription)
                    }
                    
                    return test.flatMap { test -> Single<Test> in
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
                    .trackActivity(self.loadTestActivityIndicator)
                    .asDriver(onErrorDriveWith: .never())
            }
    }

    func makeUserTestId() -> Observable<Int> {
        testElement
            .compactMap { $0.userTestId }
            .asObservable()
    }
    
    func makeCurrentAnswers() -> Observable<AnswerElement?> {
        Observable
            .merge(answers.asObservable(),
                   didTapNext.map { nil },
                   didTapIndexQuestion.map { _ in nil }
            )
    }
    
    func endOfTest() -> Observable<Bool> {
        selectedAnswers
            .compactMap { $0 }
            .withLatestFrom(testElement) {
                ($0, $1.userTestId)
            }
            .flatMapLatest { [weak self] element, userTestId -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Bool?> {
                    self.questionManager
                        .sendAnswer(
                            questionId: element.questionId,
                            userTestId: userTestId,
                            answerIds: element.answerIds
                        )
                        .do(onSuccess: { [weak self] _ in
                            self?.answeredQuestionId.accept(element.questionId)
                        })
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
                    .trackActivity(self.sendAnswerActivityIndicator)
                    .compactMap { $0 }
                    .asObservable()
            }
            .catchAndReturn(false)
    }
    
    func makeBottomState() -> Driver<SITestBottomView.State> {
        Driver
            .combineLatest(
                question,
                currentAnswers.asDriver(onErrorJustReturn: nil),
                testMode
            )
            .map { question, answers, testMode -> SITestBottomView.State in
                if question.elements.contains(where: { $0.isResult }) {
                    if question.isLast {
                        return .finish
                    } else {
                        return testMode == .onAnExam ? .hidden : .next
                    }
                } else {
                    return answers?.answerIds.isEmpty == false ? .confirm : .hidden
                }
            }
            .startWith(.hidden)
            .distinctUntilChanged()
    }
    
    func makeTestMode() -> Driver<TestMode?> {
        profileManager
            .obtainTestMode(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
    }
}

// MARK: Additional
private extension SITestViewModel {
    enum Action {
        case index(Int)
        case `continue`
        case elements([QuestionElement])
    }
    
    enum QuestionAction {
        case elements([Question], AnswerElement?, TestMode?)
        case answered(questionId: Int)
    }
    
    var questionAccumulator: ([QuestionElement], QuestionAction) -> [QuestionElement] {
        return { old, action in
            switch action {
            case let .elements(questions, answers, testMode):
                guard !old.isEmpty else {
                    return questions.enumerated().map { index, question in
                        let answers = question.answers.map { PossibleAnswerElement(id: $0.id,
                                                                                   answer: $0.answer,
                                                                                   answerHtml: $0.answerHtml,
                                                                                   image: $0.image) }
                        
                        let content: [QuestionContentCollectionType] = [
                            question.image.map { QuestionContentCollectionType.image($0) },
                            question.video.map { QuestionContentCollectionType.video($0) }
                        ].compactMap { $0 }
                        
                        let elements: [TestingCellType] = [
                            !content.isEmpty ? .content(content) : nil,
                            .question(question.question, html: question.questionHtml),
                            .answers(answers)
                        ].compactMap { $0 }
                        
                        var referenceCellType = [TestingCellType]()
                        if let reference = question.reference, !reference.isEmpty {
                            referenceCellType.append(.reference(reference))
                        }
                        
                        return QuestionElement(
                            id: question.id,
                            elements: elements + referenceCellType,
                            isMultiple: question.multiple,
                            index: index + 1,
                            isAnswered: question.isAnswered,
                            questionsCount: questions.count,
                            isSaved: question.isSaved
                        )
                    }
                }
                
                guard let currentAnswers = answers, let currentQuestion = questions.first(where: { $0.id == currentAnswers.questionId }) else {
                    return old
                }
                
                let currentMode = questions.count > 1 ? testMode : .fullComplect
                
                guard let index = old.firstIndex(where: { $0.id == currentAnswers.questionId }) else {
                    return old
                }
                let currentElement = old[index]
                let newElements = currentElement.elements.compactMap { value -> TestingCellType? in
                    if case .reference = value { return nil }
                    
                    guard case .answers = value else { return value }
                    
                    let result = currentQuestion.answers.map { answer -> AnswerResultElement in
                        let state: AnswerState
                        
                        if currentMode == .onAnExam {
                            state = .initial
                        } else {
                            state = currentAnswers.answerIds.contains(answer.id)
                                ? answer.isCorrect ? .correct : .error
                                : answer.isCorrect ? currentQuestion.multiple ? .warning : .correct : .initial
                        }
                        
                        return AnswerResultElement(answer: answer.answer,
                                                   answerHtml: answer.answerHtml,
                                                   image: answer.image,
                                                   state: state)
                    }
                    
                    return .result(result)
                }
                
                let explanation: [TestingCellType]
                
                if [.none, .fullComplect].contains(testMode) {
                    let explanationText: TestingCellType?
                    if (currentQuestion.explanation != nil || currentQuestion.explanationHtml != nil) {
                        explanationText = .explanationText(currentQuestion.explanation ?? "", html: currentQuestion.explanationHtml ?? "")
                    } else {
                        explanationText = nil
                    }
                    
                    let explanationImages = currentQuestion.media.map { TestingCellType.explanationImage($0)}
                    
                    if explanationText != nil || !explanationImages.isEmpty {
                        explanation = [.explanationTitle] + explanationImages + [explanationText].compactMap { $0 }
                    } else {
                        explanation = []
                    }
                    
                } else {
                    explanation = []
                }
                
                var referenceCellType = [TestingCellType]()
                if let reference = currentQuestion.reference, !reference.isEmpty {
                    referenceCellType.append(.reference(reference))
                }
                
                let newElement = QuestionElement(
                    id: currentElement.id,
                    elements: newElements + explanation + referenceCellType,
                    isMultiple: currentElement.isMultiple,
                    index: currentElement.index,
                    isAnswered: currentElement.isAnswered,
                    questionsCount: currentElement.questionsCount,
                    isSaved: currentElement.isSaved
                )
                var result = old
                result[index] = newElement
                return result
            case let .answered(questionId):
                guard let index = old.firstIndex(where: { $0.id == questionId }) else {
                    return old
                }
                
                var currentElement = old[index]
                currentElement.isAnswered = true
                var result = old
                result[index] = currentElement
                return result
            }
        }
    }
    
    var currentQuestionAccumulator: ((QuestionElement?, [QuestionElement]), Action) -> (QuestionElement?, [QuestionElement]) {
        return { old, action -> (QuestionElement?, [QuestionElement]) in
            let (currentElement, elements) = old
            
            switch action {
            case let .elements(questions):
                // Проверка для вопроса дня, чтобы была возможность отобразить вопрос,
                // если юзер уже на него отвечал
                guard questions.count > 1 else { return (questions.first, questions) }
                
                // Флаг isAnswered проставлен в true либо бэком либо локально,
                // при успешной отправке ответа, в этом случае игнорм всю логику
                // и возвращаем предыдущее значение, переключение на следцющий вопрос
                // вызовет другой кейс
                if let current = questions.first(where: { $0.id == currentElement?.id }), current.isAnswered {
                    return (current, questions)
                } else {
                    let withoutAnswered = questions.filter { !$0.isAnswered }
                    let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }) ?? 0
                    return (withoutAnswered[safe: index], questions)
                }
            case let .index(index):
                return (elements[safe: index - 1] ?? currentElement, elements)
            case .continue:
                let currentIndex = elements.firstIndex(where: { $0.id == currentElement?.id }) ?? 0
                // Из массива элементов получаем подмассив, где первый елемент - текущий, затем фильтруем.
                // Нужно для кейса, когда юзер пропустил вопрос, а на следующий ответил, чтобы автоперход
                // на следующий вопрос был на следующий по порядку, а не на первый неотвеченный
                let withoutAnswered = elements.suffix(from: currentIndex).filter { !$0.isAnswered }
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 + 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            }
        }
    }
}

private extension TestingCellType {
    var isResult: Bool {
        if case .result = self {
            return true
        } else {
            return false
        }
    }
}

private extension QuestionElement {
    var isLast: Bool { index == questionsCount }
}
