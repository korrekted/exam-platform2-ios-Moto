//
//  TestViewController.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit
import RushSDK

protocol TestViewControllerDelegate: AnyObject {
    func testViewControllerDismiss()
    func testViewControllerClose(finish: TestFinishElement)
    func testViewControllerNeedPayment()
    func testViewController(finish: TestFinishElement)
}

final class TestViewController: UIViewController {
    weak var delegate: TestViewControllerDelegate?
    
    lazy var mainView = TestView(testType: testType)
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: TestViewModel
    
    private let testType: TestType
    
    private init(course: Course, testType: TestType, isTopicTest: Bool) {
        self.viewModel = TestViewModel(course: course, testType: testType, isTopicTest: isTopicTest)
        
        self.testType = testType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .empty()
            }
            
            return self.openError()
        }
        
        viewModel.loadTestActivityIndicator
            .drive(Binder(self) { base, activity in
                activity ? base.mainView.preloader.startAnimating() : base.mainView.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.sendAnswerActivityIndicator
            .drive(Binder(self) { base, activity in
                activity ? base.mainView.bottomView.preloader.start() : base.mainView.bottomView.preloader.stop()
            })
            .disposed(by: disposeBag)
        
        mainView.navigationView.rightAction.rx.tap
            .withLatestFrom(viewModel.isSavedQuestion)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)
        
        viewModel.isSavedQuestion
            .drive(Binder(self) { base, isSaved in
                base.update(favorite: isSaved)
            })
            .disposed(by: disposeBag)
        
        viewModel.question
            .drive(Binder(self) { base, element in
                base.mainView.tableView.setup(question: element)
            })
            .disposed(by: disposeBag)
        
        viewModel.rightCounterValue
            .drive(Binder(mainView) { base, element in
                base.counter.setRightContent(value: element.value, isError: element.isError)
            })
            .disposed(by: disposeBag)

        viewModel.leftCounterValue
            .drive(Binder(mainView) { base, element in
                base.counter.setLeftContent(value: element)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedAnswersRelay
            .withLatestFrom(viewModel.courseName) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                let (answers, name) = args
                
                base.viewModel.answers.accept(answers)
                base.logTapAnalytics(courseName: name, what: "answer")
            })
            .disposed(by: disposeBag)
        
        viewModel.bottomViewState
            .startWith(.hidden)
            .drive(Binder(mainView.bottomView) {
                $0.setup(state: $1)
            })
            .disposed(by: disposeBag)
        
        let currentButtonState = mainView.bottomView.button.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .share()
        
        currentButtonState
            .compactMap { $0 == .confirm ? () : nil }
            .bind(to: viewModel.didTapConfirm)
            .disposed(by: disposeBag)
        
        currentButtonState
            .compactMap { $0 == .submit ? () : nil }
            .bind(to: viewModel.didTapSubmit)
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { $0 == .back }
            .bind(to: Binder(self) { base, _ in
                base.delegate?.testViewControllerDismiss()
            })
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { $0 == .next }
            .withLatestFrom(viewModel.courseName)
            .bind(to: Binder(self) { base, name in
                base.viewModel.didTapNext.accept(Void())
                base.logTapAnalytics(courseName: name, what: "continue")
            })
            .disposed(by: disposeBag)
        
        viewModel.isEndOfTest
            .filter(!)
            .withLatestFrom(viewModel.testMode)
            .bind(with: self, onNext: { base, testMode in
                if testMode == .onAnExam {
                    base.viewModel.didTapNext.accept(Void())
                }
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.expandContent
            .withLatestFrom(viewModel.courseName) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                let (content, courseName) = args
                
                base.logTapAnalytics(courseName: courseName, what: "media")
                
                switch content {
                case let .image(url):
                    let controller = PhotoViewController.make(imageURL: url)
                    base.present(controller, animated: true)
                case let .video(url):
                    let controller = AVPlayerViewController()
                    controller.view.backgroundColor = .black
                    let player = AVPlayer(url: url)
                    controller.player = player
                    base.present(controller, animated: true) { [weak player] in
                        player?.play()
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.needPayment
            .filter { $0 }
            .emit(to: Binder(self) { base, needPayment in
                base.delegate?.testViewControllerNeedPayment()
            })
            .disposed(by: disposeBag)
            
        viewModel.needPayment
            .filter(!)
            .withLatestFrom(viewModel.courseName)
            .emit(onNext: { [weak self] name in
                self?.logAnalytics(courseName: name)
            })
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { [.submit, .back].contains($0) }
            .withLatestFrom(viewModel.needPayment)
            .subscribe(onNext: { needPayment in
                guard !needPayment else {
                    return
                }
                
                RateManagerCore().showFirstAfterPassRateAlert()
            })
            .disposed(by: disposeBag)
        
        mainView.navigationView.leftAction.rx.tap
            .withLatestFrom(viewModel.userTestId)
            .withLatestFrom(viewModel.courseName) { ($0, $1) }
            .withLatestFrom(viewModel.isTopicTest) { ($0.0, $0.1, $1) }
            .bind(to: Binder(self) { base, args in
                let (userTestId, courseName, isTopicTest) = args
                
                let finish = TestFinishElement(userTestId: userTestId,
                                               courseName: courseName,
                                               testType: base.testType,
                                               isTopicTest: isTopicTest)
                
                base.logTapAnalytics(courseName: courseName, what: "close")
                
                base.delegate?.testViewControllerClose(finish: finish)
            })
            .disposed(by: disposeBag)
        
        viewModel.testFinishElement
            .drive(Binder(self) { base, element in
                base.logTapAnalytics(courseName: element.courseName, what: "finish test")
                
                base.delegate?.testViewController(finish: element)
            })
            .disposed(by: disposeBag)
        
        setupTitles()
    }
}

// MARK: Make
extension TestViewController {
    static func make(course: Course, testType: TestType, isTopicTest: Bool) -> TestViewController {
        let controller = TestViewController(course: course, testType: testType, isTopicTest: isTopicTest)
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
}

// MARK: Public
extension TestViewController {
    func restart(userTestId: Int) {
        viewModel.didTapRestart.accept(userTestId)
    }
}

// MARK: Private
private extension TestViewController {
    func setupTitles() {
        let leftCounterTitle: String
        let rightCounterTitle: String
        
        switch testType {
        case .timed:
            leftCounterTitle = "Question.Counter.Question".localized
            rightCounterTitle = "Question.Counter.RemainingTime".localized
        default:
            leftCounterTitle = "Question.Counter.Score".localized
            rightCounterTitle = "Question.Counter.Question".localized
        }
        
        mainView.navigationView.setTitle(title: testType.name)
        mainView.counter.setup(leftTitle: leftCounterTitle, rightTitle: rightCounterTitle)
    }
    
    func update(favorite: Bool) {
        let image = favorite ? UIImage(named: "Question.Bookmark.Check") : UIImage(named: "Question.Bookmark.Uncheck")
        mainView.navigationView.rightAction.setImage(image, for: .normal)
    }
    
    func logAnalytics(courseName: String) {
        let name = TestAnalytics.name(mode: testType)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Question Screen",
                      parameters: ["course": courseName,
                                   "mode": name])
    }
    
    func logTapAnalytics(courseName: String, what: String) {
        let name = TestAnalytics.name(mode: testType)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Question Tap",
                      parameters: ["course": courseName,
                                   "mode": name,
                                   "what": what])
    }
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
