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

final class TestViewController: UIViewController {
    lazy var mainView = TestView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestViewModel()
    
    var didTapSubmit: ((TestStatsElement) -> Void)?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navigationView.leftAction.addTarget(self, action: #selector(popAction), for: .touchUpInside)
        
        let courseName = viewModel.courseName
        
        viewModel.question
            .drive(Binder(self) { base, element in
                base.mainView.tableView.setup(question: element)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedAnswers
            .withLatestFrom(courseName) { ($0, $1) }
            .subscribe(onNext: { [weak self] stub in
                let (answers, name) = stub
                
                self?.viewModel.selectedAnswersRelay.accept(answers)
                self?.logTapAnalytics(courseName: name, what: "answer")
            })
            .disposed(by: disposeBag)
        
        let currentButtonState = mainView.bottomButton.rx.tap
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
                base.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .withLatestFrom(courseName)
            .subscribe(onNext: { [weak self] name in
                self?.viewModel.didTapNext.accept(Void())
                self?.logTapAnalytics(courseName: name, what: "continue")
            })
            .disposed(by: disposeBag)
        
        viewModel.question
            .map { $0.questionsCount == 1 }
            .distinctUntilChanged()
            .drive(Binder(mainView) {
                $0.needAddingCounter(isOne: $1)
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
        
        let isHiddenNext = Driver
            .merge(
                viewModel.isEndOfTest,
                mainView.nextButton.rx.tap.asDriver().map { _ in true },
                viewModel.loadNextTestSignal.asDriver(onErrorDriveWith: .empty()).map { _ in true }
            )
            .startWith(true)
        
        isHiddenNext
            .drive(mainView.nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        let nextOffset = isHiddenNext
            .map { [weak mainView] isHidden -> CGFloat in
                let bottomOffset = mainView.map { $0.bounds.height - $0.nextButton.frame.minY + 9.scale } ?? 0
                return isHidden ? 0 : bottomOffset
            }
        
        Observable
            .combineLatest(nextOffset.asObservable(), viewModel.bottomViewState.asObservable()) { nextOffset, bottomState in
                bottomState == .hidden ? nextOffset : 195.scale
            }
            .distinctUntilChanged()
            .bind(to: Binder(mainView.tableView) {
                $0.contentInset.bottom = $1
            })
            .disposed(by: disposeBag)
        
        viewModel.testStatsElement
            .withLatestFrom(courseName) { ($0, $1) }
            .bind(to: Binder(self) { base, stub in
                let (element, name) = stub
                let testStatsController = TestStatsViewController.make(element: element)
                testStatsController.didTapNext = base.loadNext
                testStatsController.didTapTryAgain = base.tryAgain
                base.present(testStatsController, animated: true)
                base.logTapAnalytics(courseName: name, what: "finish test")
            })
            .disposed(by: disposeBag)
        
        viewModel.bottomViewState
            .drive(Binder(mainView) {
                $0.setupBottomButton(for: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit { [weak self] message in
                Toast.notify(with: message, style: .danger)
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        viewModel.needPayment
            .filter { $0 }
            .emit { [weak self] _ in
                UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true) { [weak self] in
                    // Без задержки контроллер не попается
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.navigationController?.popViewController(animated: false)
                    }
                }
            }
            .disposed(by: disposeBag)
            
        viewModel.needPayment
            .filter(!)
            .withLatestFrom(courseName)
            .emit(onNext: { [weak self] name in
                self?.logAnalytics(courseName: name)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentTestType
            .bind(to: Binder(mainView) { base, testType in
                let leftCounterTitle: String
                let rightCounterTitle: String
                
                switch testType {
                case .timedQuizz:
                    leftCounterTitle = "Question.Counter.Question".localized
                    rightCounterTitle = "Question.Counter.RemainingTime".localized
                default:
                    leftCounterTitle = "Question.Counter.Score".localized
                    rightCounterTitle = "Question.Counter.Question".localized
                }
                
                base.navigationView.setTitle(title: testType.title)
                base.counter.setup(leftTitle: leftCounterTitle, rightTitle: rightCounterTitle)
            })
            .disposed(by: disposeBag)
        
        viewModel.isSavedQuestion
            .drive(Binder(mainView) {
                $0.saveQuestion($1)
            })
            .disposed(by: disposeBag)
        
        mainView.navigationView.rightAction.rx.tap
            .withLatestFrom(viewModel.isSavedQuestion)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { [.submit, .back].contains($0) }
            .withLatestFrom(viewModel.needPayment)
            .subscribe(onNext: { needPayment in
                guard !needPayment else { return }
                RateManagerCore().showFirstAfterPassRateAlert()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestViewController {
    static func make(testTypes: [TestType], activeSubscription: Bool, courseId: Int, isTopicTest: Bool) -> TestViewController {
        let controller = TestViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.isTopicTest = isTopicTest
        controller.viewModel.activeSubscription = activeSubscription
        controller.viewModel.testTypes = testTypes
        controller.viewModel.courseId.accept(courseId)
        return controller
    }
}

extension TestViewController {
    func loadNext() {
        viewModel.loadNextTestSignal.accept(())
    }
    
    func tryAgain() {
        viewModel.tryAgainSignal.accept(())
    }
}

// MARK: Private
private extension TestViewController {
    func logAnalytics(courseName: String) {
        guard let type = viewModel.testType else {
            return
        }
        
        let name = TestAnalytics.name(mode: type)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Question Screen", parameters: ["course": courseName,
                                                            "mode": name])
    }
    
    func logTapAnalytics(courseName: String, what: String) {
        guard let type = viewModel.testType else {
            return
        }
        
        let name = TestAnalytics.name(mode: type)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Question Tap", parameters: ["course": courseName,
                                                         "mode": name,
                                                         "what": what])
    }
    
    @objc func popAction() {
        QuestionManagerMediator.shared.testClosed()
        navigationController?.popViewController(animated: true)
    }
}

class ZoomImageViewController: UIViewController {
    
    var imageScrollView: ImageScrollView!
    
    private var image: UIImage?
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        if let image = image {
            imageScrollView.set(image: image)
        }
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }


}
