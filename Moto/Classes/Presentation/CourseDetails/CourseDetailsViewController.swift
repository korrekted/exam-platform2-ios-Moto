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
        
        let courseIdAndActiveSubscription = Observable
            .combineLatest(
                viewModel.courseId.asObservable(),
                viewModel.activeSubscription
            )
            .share(replay: 1)
        
        mainView.tableView.selectedTestId
            .withLatestFrom(courseIdAndActiveSubscription) { ($0, $1) }
            .bind(to: Binder(self) { base, tuple in
                let (testId, (courseId, activeSubscription)) = tuple
                
                let controller = TestViewController.make(testType: .get(testId: testId), activeSubscription: activeSubscription, courseId: courseId, isTopicTest: true)
                base.parent?.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable<SITestType>
            .merge(
                mainView.savedButton.rx.tap.map { _ in .saved },
                mainView.incorrectButton.rx.tap.map { _ in .incorrect }
            )
            .withLatestFrom(courseIdAndActiveSubscription) { ($0, $1) }
            .bind(to: Binder(self) { base, tuple in
                let (testType, (courseId, activeSubscription)) = tuple
                if activeSubscription {
                    let controller = SITestViewController.make(testType: testType, activeSubscription: activeSubscription, courseId: courseId)
                    base.parent?.navigationController?.pushViewController(controller, animated: true)
                } else {
                    UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .didTapLearnMore
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
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
    @objc func popAction() {
        navigationController?.popViewController(animated: true)
    }
}
