//
//  SITestViewController.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 07.04.2021.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit

final class SITestViewController: UIViewController {
    lazy var mainView = SITestView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = SITestViewModel()
    
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
        
        let isLoading = viewModel.question
            .map { _ in false }
            .startWith(true)
        
        isLoading
            .drive(mainView.loader.isLoading)
            .disposed(by: disposeBag)
        
        isLoading
            .drive(mainView.tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedAnswers
            .bind(to: viewModel.selectedSIAnswers)
            .disposed(by: disposeBag)
        
        mainView.progressView
            .selectedIndex
            .bind(to: viewModel.selectedIndex)
            .disposed(by: disposeBag)
        
        let currentButtonState = mainView.bottomButton.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .share()
        
        currentButtonState
            .compactMap { $0 == .confirm ? () : nil }
            .bind(to: viewModel.didTapConfirm)
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { $0 == .finish }
            .bind(to: Binder(self) { base, _ in
                base.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .withLatestFrom(courseName)
            .subscribe(onNext: { [weak self] name in
                self?.viewModel.didTapNext.accept(Void())
            })
            .disposed(by: disposeBag)
        
        let isHiddenNext = Driver
            .merge(
                viewModel.isEndOfTest,
                mainView.nextButton.rx.tap.asDriver().map { _ in true },
                mainView.progressView.selectedIndex.map { _ in true }.asDriver(onErrorDriveWith: .empty())
            )
        
        isHiddenNext
            .drive(mainView.nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        let nextOffset = isHiddenNext
            .compactMap { [weak mainView] isHidden -> CGFloat? in
                let bottomOffset = mainView.map { $0.bounds.height - $0.nextButton.frame.minY + 9.scale }
                return isHidden ? 32.scale : bottomOffset
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
        
        viewModel.isSavedQuestion
            .drive(Binder(mainView) {
                $0.saveQuestion($1)
            })
            .disposed(by: disposeBag)
        
        viewModel.questionProgress
            .drive(Binder(mainView.progressView) {
                $0.setup(elements: $1)
            })
            .disposed(by: disposeBag)
        
        mainView.navigationView.rightAction.rx.tap
            .withLatestFrom(viewModel.isSavedQuestion)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SITestViewController {
    static func make(testType: SITestType, activeSubscription: Bool, courseId: Int) -> SITestViewController {
        let controller = SITestViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.mainView.navigationView.setTitle(title: testType.testName)
        controller.mainView.navigationView.rightAction.isHidden = testType == .incorrect
        controller.viewModel.activeSubscription = activeSubscription
        controller.viewModel.testType.accept(testType)
        controller.viewModel.courseId.accept(courseId)
        return controller
    }
}

// MARK: Private
private extension SITestViewController {
    @objc func popAction() {
        QuestionManagerMediator.shared.testClosed()
        navigationController?.popViewController(animated: true)
    }
}

private extension SITestType {
    var testName: String {
        switch self {
        case .saved:
            return "Saved"
        case .incorrect:
            return "Incorrect"
        }
    }
}
