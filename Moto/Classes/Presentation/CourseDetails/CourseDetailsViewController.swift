//
//  CourseDetailsViewController.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 24.04.2021.
//

import UIKit
import RxSwift

class CourseDetailsViewController: UIViewController {
    
    lazy var mainView = CourseDetailsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = CourseDetailsViewModel()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.navigationView.leftAction.addTarget(self, action: #selector(popAction), for: .touchUpInside)
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.activity
            .drive(onNext: { [weak self] activity in
                guard let self = self else {
                    return
                }
                
                self.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.passRate
            .drive(Binder(mainView.progressView) {
                $0.setProgress(percent: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .elements
            .drive(onNext: { [mainView] elements in
                mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        let courseAndActiveSubscription = Observable
            .combineLatest(
                viewModel.course.compactMap { $0 }.asObservable(),
                viewModel.activeSubscription
            )
            .share(replay: 1)
        
        mainView.tableView.selectedTestId
            .withLatestFrom(courseAndActiveSubscription) { ($0, $1) }
            .withLatestFrom(viewModel.config) { ($0, $1) }
            .bind(to: Binder(self) { base, tuple in
                let ((testId, (course, activeSubscription)), config) = tuple
                let types: [TestType]
                
                if activeSubscription, let selected = config.first(where: { $0.id == testId }) {
                    types = config
                        .split(separator: selected)
                        .reversed()
                        .flatMap { $0 }
                        .reduce(into: [.get(testId: selected.id)]) { old, new in
                            old.append(.get(testId: new.id))
                        }
                } else {
                    types = [.get(testId: testId)]
                }
                
                TestCoordinator.shared.start(testTypes: types, course: course, isTopicTest: true, from: base)
            })
            .disposed(by: disposeBag)
        
        Observable<SITestType>
            .merge(
                mainView.savedButton.rx.tap.map { _ in .saved },
                mainView.incorrectButton.rx.tap.map { _ in .incorrect }
            )
            .withLatestFrom(courseAndActiveSubscription) { ($0, $1) }
            .bind(to: Binder(self) { base, tuple in
                let (testType, (course, activeSubscription)) = tuple
                if activeSubscription {
                    let vc = SITestViewController.make(course: course, testType: testType)
                    base.present(vc, animated: true)
                } else {
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(PaygateViewController.make(), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .didTapLearnMore
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(PaygateViewController.make(), animated: true)
            })
            .disposed(by: disposeBag)
        
    }
}

// MARK: Make
extension CourseDetailsViewController {
    static func make(course: Course) -> CourseDetailsViewController {
        let controller = CourseDetailsViewController()
        controller.viewModel.course.accept(course)
        controller.mainView.navigationView.setTitle(title: course.name)
        return controller
    }
}

// MARK: Private
private extension CourseDetailsViewController {
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
        let empty = mainView.tableView.elements.isEmpty
        
        let inProgress = empty && activity
        
        inProgress ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    @objc func popAction() {
        navigationController?.popViewController(animated: true)
    }
}
