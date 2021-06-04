//
//  TestStatsViewController.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class TestStatsViewController: UIViewController {
    lazy var mainView = TestStatsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestStatsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    var didTapNext: (() -> Void)?
    var didTapTryAgain: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.elements.startWith([])
            .drive(Binder(mainView.tableView) {
                $0.setup(elements: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.testName
            .drive(Binder(mainView.navigationView){
                $0.setTitle(title: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.tryAgainIsHidden
            .drive(mainView.tryAgainButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedFilter
            .bind(to: viewModel.filterRelay)
            .disposed(by: disposeBag)
        
        mainView.navigationView.rightAction.rx.tap
            .bind(to: Binder(self) { base, _ in
                (base.presentingViewController as? UINavigationController)?.popViewController(animated: false)
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.nextTestButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.didTapNext?()
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.tryAgainButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.didTapTryAgain?()
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.courseName
            .drive(onNext: { [weak self] name in
                self?.logAnalytics(courseName: name)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestStatsViewController {
    static func make(element: TestStatsElement) -> TestStatsViewController {
        let controller = TestStatsViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.isTopicTest = element.isTopicTest
        controller.viewModel.userTestId.accept(element.userTestId)
        controller.viewModel.testType.accept(element.testType)
        if case .get = element.testType {
            controller.mainView.configureAddingButtons(isNextEnabled: element.isEnableNext, isTopicTest: element.isTopicTest)
        }
        return controller
    }
}

// MARK: Private
private extension TestStatsViewController {
    func logAnalytics(courseName: String) {
        guard let type = viewModel.testType.value else {
            return
        }
        
        let name = TestAnalytics.name(mode: type)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Test Stats Screen", parameters: ["course": courseName,
                                                              "mode": name])
    }
}
