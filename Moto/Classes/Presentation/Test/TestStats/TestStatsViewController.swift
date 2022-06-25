//
//  TestStatsViewController.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

protocol TestStatsViewControllerDelegate: AnyObject {
    func testStatsViewControllerDidTapped(event: TestStatsViewController.Event)
}

final class TestStatsViewController: UIViewController {
    enum Event {
        case close
        case restart(Int)
        case nextTest
    }
    
    weak var delegate: TestStatsViewControllerDelegate?
    
    lazy var mainView = TestStatsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestStatsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
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
                base.delegate?.testStatsViewControllerDidTapped(event: .close)
            })
            .disposed(by: disposeBag)
        
        mainView.nextTestButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.delegate?.testStatsViewControllerDidTapped(event: .nextTest)
            })
            .disposed(by: disposeBag)
        
        mainView.tryAgainButton.rx.tap
            .withLatestFrom(viewModel.userTestId)
            .bind(to: Binder(self) { base, userTestId in
                if let userTestId = userTestId {
                    base.delegate?.testStatsViewControllerDidTapped(event: .restart(userTestId))
                }
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
    static func make(userTestId: Int, testType: TestType, isEnableNext: Bool, isTopicTest: Bool) -> TestStatsViewController {
        let controller = TestStatsViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.isTopicTest = isTopicTest
        controller.viewModel.userTestId.accept(userTestId)
        controller.viewModel.testType.accept(testType)
        controller.mainView.configureAddingButtons(isNextEnabled: isEnableNext, isTopicTest: isTopicTest)
        return controller
    }
}

// MARK: Private
private extension TestStatsViewController {
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
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
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
