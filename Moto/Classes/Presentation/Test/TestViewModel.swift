//
//  TestViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import RxSwift
import RxCocoa

final class TestViewModel {
    
    var activeSubscription = true

    var testType = BehaviorRelay<TestType?>(value: nil)
    let courseId = BehaviorRelay<Int?>(value: nil)
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let didTapSubmit = PublishRelay<Void>()
    let loadNextTestSignal = PublishRelay<Void>()
    let tryAgainSignal = PublishRelay<Void>()
    let didTapMark = PublishRelay<Bool>()
    let selectedAnswersRelay = BehaviorRelay<[AnswerElement]>(value: [])
    
    lazy var courseName = makeCourseName()
    lazy var question = makeQuestion()
    lazy var isEndOfTest = endOfTest()
    lazy var bottomViewState = makeBottomState()
    lazy var errorMessage = makeErrorMessage()
    lazy var needPayment = makeNeedPayment()
    lazy var leftCounterValue = makeLeftCounterContent()
    lazy var rightCounterValue = makeRightCounterContent()
    lazy var testStatsElement = makeTestStatsElement()
    lazy var isSavedQuestion = makeIsSavedQuestion()
    lazy var userTestId = currentTestElement.map { $0.element?.userTestId }
    
    private(set) lazy var currentTestType = makeCurrentTestType().share(replay: 1, scope: .forever)
    private(set) var currentType: TestType? = nil
    
    private lazy var questionManager = QuestionManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    private lazy var scoreRelay = PublishRelay<Bool>()
    
    private lazy var testElement = loadTest().share(replay: 1, scope: .forever)
    private lazy var currentTestElement = Observable.merge(testElement, tryAgainTest()).share(replay: 1, scope: .forever)
    
    private lazy var selectedAnswers = makeSelectedAnswers().share(replay: 1, scope: .forever)
    
    private lazy var questionProgress = makeQuestionProgress().share(replay: 1, scope: .forever)
    private lazy var timer = makeTimer().share(replay: 1, scope: .forever)
    
    var isTopicTest = false
}

// MARK: Private
private extension TestViewModel {
    func makeCourseName() -> Driver<String> {
        testElement
            .map { $0.element?.name }
            .withLatestFrom(courseManager.rxGetSelectedCourse()) { ($0, $1) }
            .compactMap { name, course -> String? in
                guard let name = name, !name.isEmpty else { return course?.name }
                return name
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQuestion() -> Driver<QuestionElement> {
        let questions = currentTestElement
            .compactMap { $0.element?.questions }
            .map(questionElementMapper)
        
        let currentQuestion = Observable<Action>
            .merge(questions.map { .elements($0) }, didTapNext.map { _ in .next })
            .scan((nil, []),accumulator: currentQuestionAccumulator)
            .compactMap { $0.0.map { TestAction.question($0) } }
        
        let test = Observable
            .merge(currentQuestion, selectedAnswers.map { .answer($0) })
            .scan(nil, accumulator: answerQuestionAccumulator)
            .compactMap { $0 }
        
        return test.asDriver(onErrorDriveWith: .empty())
    }
    
    func makeSelectedAnswers() -> Observable<[AnswerElement]> {
        Observable
            .merge(
                didTapConfirm.withLatestFrom(selectedAnswersRelay),
                loadNextTestSignal.map { _ in [] },
                tryAgainSignal.map { _ in [] }
            )
            .startWith([])
    }
    
    func tryAgainTest() -> Observable<Event<Test>> {
        tryAgainSignal
            .withLatestFrom(testElement)
            .withLatestFrom(courseId) { ($0, $1) }
            .flatMapLatest { [weak self] value, courseId -> Observable<Event<Test>> in
                guard let self = self, let userTestId = value.element?.userTestId, let courseId = courseId else { return .empty() }
                
                return self.questionManager
                    .againTest(courseId: courseId, testId: userTestId, activeSubscription: self.activeSubscription)
                    .compactMap { $0 }
                    .asObservable()
                    .materialize()
                    .filter {
                        guard case .completed = $0 else { return true }
                        return false
                    }
            }
    }
    
    func loadTest() -> Observable<Event<Test>> {
        Observable.combineLatest(courseId, currentTestType)
            .flatMapLatest { [weak self] courseId, type -> Observable<Event<Test>> in
                guard let self = self,  let courseId = courseId else { return .empty() }
                
                let test: Single<Test?>
                
                switch type {
                case let .get(testId):
                    test = self.questionManager.retrieve(courseId: courseId,
                                                         testId: testId,
                                                         time: nil,
                                                         activeSubscription: self.activeSubscription)
                case let .timedQuizz(minutes):
                    test = self.questionManager.retrieve(courseId: courseId,
                                                         testId: nil,
                                                         time: minutes,
                                                         activeSubscription: self.activeSubscription)
                case .tenSet:
                    test = self.questionManager.retrieveTenSet(courseId: courseId,
                                                               activeSubscription: self.activeSubscription)
                case .failedSet:
                    test = self.questionManager.retrieveFailedSet(courseId: courseId,
                                                                  activeSubscription: self.activeSubscription)
                case .qotd:
                    test = self.questionManager.retrieveQotd(courseId: courseId,
                                                             activeSubscription: self.activeSubscription)
                case .randomSet:
                    test = self.questionManager.retrieveRandomSet(courseId: courseId,
                                                                  activeSubscription: self.activeSubscription)
                }
                
                return test
                    .compactMap { $0 }
                    .asObservable()
                    .materialize()
                    .filter {
                        guard case .completed = $0 else { return true }
                        return false
                    }
            }
    }
    
    func makeCurrentTestType() -> Observable<TestType> {
        testType
            .compactMap { $0 }
            .take(1)
            .concat(loadNextTestSignal.map { .get(testId: nil) })
            .do(onNext: { [weak self] in
                self?.currentType = $0
            })
    }
    
    func makeErrorMessage() -> Signal<String> {
        currentTestElement
            .compactMap { $0.error?.localizedDescription }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    func makeNeedPayment() -> Signal<Bool> {
        currentTestElement
            .map { [weak self] event in
                guard let self = self, let element = event.element else { return false }
                return self.activeSubscription ? false : element.paid
            }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    func makeTestStatsElement() -> Observable<TestStatsElement> {
        let didFinishTest = timer
            .compactMap { $0 == 0 ? () : nil }
            .withLatestFrom(currentTestElement)
            .flatMap { [weak self] value -> Observable<Int> in
                guard let self = self, let userTestId  = value.element?.userTestId else { return .empty() }
                return self.questionManager
                    .finishTest(userTestId: userTestId)
                    .andThen(.just(userTestId))
            }
        
        let submit = didTapSubmit
            .withLatestFrom(currentTestElement)
            .compactMap { $0.element?.userTestId }
        
        return Observable.merge(didFinishTest, submit)
            .withLatestFrom(currentTestType) { ($0, $1) }
            .compactMap { [weak self] userTestId, testType -> TestStatsElement? in
                guard let self = self else { return nil }
                return TestStatsElement(userTestId: userTestId, testType: testType, isEnableNext: true, isTopicTest: self.isTopicTest)
            }
    }
    
    func endOfTest() -> Driver<Bool> {
        selectedAnswers
            .withLatestFrom(question) { ($0, $1) }
            .withLatestFrom(testElement) { ($0.0, $0.1, $1.element?.userTestId) }
            .flatMapLatest { [questionManager] answers, question, userTestId -> Observable<Bool> in
                guard let userTestId = userTestId, !answers.isEmpty else {
                    return .just(false)
                    
                }
                
                return questionManager
                    .sendAnswer(
                        questionId: question.id,
                        userTestId: userTestId,
                        answerIds: answers.map { $0.id }
                    )
                    .catchAndReturn(nil)
                    .compactMap { $0 }
                    .asObservable()
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeBottomState() -> Driver<TestBottomButtonState> {
        let bottomState = Driver
            .combineLatest(
                isEndOfTest.startWith(false),
                question,
                selectedAnswersRelay.asDriver(onErrorJustReturn: [])
            )
            .map { isEndOfTest, question, answers -> TestBottomButtonState in
                if isEndOfTest {
                    return question.questionsCount == 1 ? .back : .submit
                } else {
                    return answers.isEmpty ? .hidden : .confirm
                }
            }
            .startWith(.hidden)
            .distinctUntilChanged()
        
        return loadNextTestSignal
            .startWith(())
            .flatMapLatest { _ in bottomState }
            .asDriver(onErrorJustReturn: .hidden)
    }
    
    func makeScore() -> Observable<String> {
        Observable
            .merge(tryAgainSignal.asObservable(), loadNextTestSignal.asObservable())
            .startWith(())
            .flatMapLatest { [scoreRelay] _ in
                scoreRelay
                    .scan(0) { $1 ? $0 + 1 : $0 }
                    .map { score -> String in
                        score < 10 ? "0\(score)" : "\(score)"
                    }
                    .startWith("00")
                    .distinctUntilChanged()
            }
    }
    
    func makeTimer() -> Observable<Int> {
        currentTestElement
            .withLatestFrom(currentTestType)
            .flatMapLatest {testType -> Observable<Int> in
                guard case let .timedQuizz(minutes) = testType else { return .empty() }
                let startTime = CFAbsoluteTimeGetCurrent()
                let seconds = minutes * 60
                return Observable<Int>
                    .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
                    .map { _ in Int(CFAbsoluteTimeGetCurrent() - startTime) }
                    .take(until: { $0 >= seconds }, behavior: .inclusive)
                    .map { max(0, seconds - $0) }
                    .distinctUntilChanged()
            }
    }
    
    func makeLeftCounterContent() -> Driver<String> {
        currentTestType
            .flatMapLatest { [weak self] type -> Observable<String> in
                guard let self = self else { return .just("00") }
                
                let result: Observable<String>
                if case .timedQuizz = type {
                    result = self.questionProgress
                } else {
                    result = self.makeScore()
                }
                
                return result
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeRightCounterContent() -> Driver<(value:String, isError: Bool)> {
        currentTestType
            .flatMapLatest { [weak self] type -> Observable<(value: String, isError: Bool)> in
                guard let self = self else { return .just((value: "00", isError: false)) }
                
                let result: Observable<(value: String, isError: Bool)>
                if case .timedQuizz = type {
                    result = self.timer
                        .map { (value: $0.secondsToString(), isError: $0 < 10) }
                } else {
                    result = self.questionProgress.map { (value: $0, isError: false) }
                }
                
                return result
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQuestionProgress() -> Observable<String> {
        question
            .map { "\($0.index)/\($0.questionsCount)" }
            .asObservable()
    }
    
    func makeIsSavedQuestion() -> Driver<Bool> {
        let isSavedQuestion = didTapMark
            .withLatestFrom(question.map { $0.id }) { ($0, $1) }
            .flatMapFirst { [weak self] isSaved, questionId -> Observable<Bool> in
                guard let self = self else { return .empty() }
                
                let request = isSaved
                    ? self.questionManager.removeSavedQuestion(questionId: questionId)
                    : self.questionManager.saveQuestion(questionId: questionId)
                
                return request
                    .andThen(Observable.just(!isSaved))
                    .catchAndReturn(isSaved)
            }
        
        let nextQuestion = didTapNext
            .map { _ in false }
        
        return Observable
            .merge(isSavedQuestion, nextQuestion)
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
    }
}

// MARK: Additional
private extension TestViewModel {
    enum Action {
        case next
        case previos
        case elements([QuestionElement])
    }
    
    enum TestAction {
        case question(QuestionElement)
        case answer([AnswerElement])
    }
    
    var questionElementMapper: ([Question]) -> [QuestionElement] {
        return { questions in
            return questions.enumerated().map { index, question -> QuestionElement in
                let answers: [TestingCellType] = question.answers
                    .map { .answer(AnswerElement(id: $0.id, answer: $0.answer, image: $0.image, state: .initial, isCorrect: $0.isCorrect)) }
                
                let content: [QuestionContentType] = [
                    question.image.map { .image($0) },
                    question.video.map { .video($0) }
                ].compactMap { $0 }
                
                let elements: [TestingCellType] = [
                    !content.isEmpty ? .content(content) : nil,
                    .question(question.question, html: question.questionHtml)
                ].compactMap { $0 } + answers
                
                return QuestionElement(
                    id: question.id,
                    elements: elements,
                    isMultiple: question.multiple,
                    index: index + 1,
                    isAnswered: question.isAnswered,
                    questionsCount: questions.count,
                    explanation: question.explanation,
                    isResult: false
                )
            }
        }
    }
    
    var currentQuestionAccumulator: ((QuestionElement?, [QuestionElement]), Action) -> (QuestionElement?, [QuestionElement]) {
        return { old, action -> (QuestionElement?, [QuestionElement]) in
            let (currentElement, elements) = old
            let withoutAnswered = elements.filter { !$0.isAnswered }
            switch action {
            case let .elements(questions):
                // Проверка для вопроса дня, чтобы была возможность отобразить вопрос,
                // если юзер уже на него отвечал
                guard questions.count > 1 else { return (questions.first, questions) }
                
                let withoutAnswered = questions.filter { !$0.isAnswered }
                return (withoutAnswered.first, questions)
            case .next:
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 + 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            case .previos:
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 - 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            }
        }
    }
    
    var answerQuestionAccumulator: (QuestionElement?, TestAction) -> QuestionElement? {
        return { [weak self] old, action -> QuestionElement? in
            switch action {
            case .question(let question):
                return question
            case .answer(let answers):
                guard let currentQuestion = old else { return old }
                var answersState: [AnswerState] = []
                let answerIds = answers.map { $0.id }
                let newElements = currentQuestion.elements.map { element -> TestingCellType in
                    guard case var .answer(value) = element else { return element }
                    
                    let state: AnswerState = answerIds.contains(value.id)
                        ? value.isCorrect ? .correct : .error
                        : value.isCorrect ? currentQuestion.isMultiple ? .warning : .correct : .initial
                    
                    value.state = state
                    answersState.append(state)
                    
                    return .answer(value)
                }
                
                let isIncorrect = answersState
                    .contains(where: { $0 == .warning || $0 == .error })
                
                self?.scoreRelay.accept(!isIncorrect)
                
                let explanation: [TestingCellType] = currentQuestion.explanation.map { [.explanation($0)] } ?? []
                
                return QuestionElement(
                    id: currentQuestion.id,
                    elements: newElements + explanation,
                    isMultiple: currentQuestion.isMultiple,
                    index: currentQuestion.index,
                    isAnswered: currentQuestion.isAnswered,
                    questionsCount: currentQuestion.questionsCount,
                    explanation: currentQuestion.explanation,
                    isResult: true
                )
            }
        }
    }
}

private extension TestViewModel {
    
    func logAnswerAnalitycs(isCorrect: Bool) {
        guard let type = currentType, let courseName = courseManager.getSelectedCourse()?.name else {
            return
        }
        let name = isCorrect ? "Question Answered Correctly" : "Question Answered Incorrectly"
        let mode = TestAnalytics.name(mode: type)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: name, parameters: ["course" : courseName, "mode": mode])
    }
}

private extension Int {
    func secondsToString() -> String {
        let seconds = self
        var mins = 0
        var secs = seconds
        if seconds >= 60 {
            mins = Int(seconds / 60)
            secs = seconds - (mins * 60)
        }
        
        return String(format: "%02d:%02d", mins, secs)
    }
}
