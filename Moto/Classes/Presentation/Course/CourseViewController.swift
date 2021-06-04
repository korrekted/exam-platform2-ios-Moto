//
//  CourseViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class CourseViewController: UIViewController {
    var mainView = CourseView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = CourseViewCoordinator(parentVC: self)
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActionsToTabs()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.update(selectedTab: .study)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension CourseViewController {
    static func make() -> NursingNavigationController {
        let vc = CourseViewController()
        let nc = NursingNavigationController(rootViewController: vc)
        vc.navigationItem.backButtonTitle = " "
        return nc
    }
}
 
// MARK: Private
private extension CourseViewController {
    func addActionsToTabs() {
        let studyGesture = UITapGestureRecognizer()
        mainView.tabView.studyItem.isUserInteractionEnabled = true
        mainView.tabView.studyItem.addGestureRecognizer(studyGesture)
        
        let statsGesture = UITapGestureRecognizer()
        mainView.tabView.statsItem.isUserInteractionEnabled = true
        mainView.tabView.statsItem.addGestureRecognizer(statsGesture)
        
        Observable
            .merge([
                studyGesture.rx.event.map { _ in TabView.Tab.study },
                statsGesture.rx.event.map { _ in TabView.Tab.stats },
            ])
            .subscribe(onNext: { [weak self] tab in
                self?.update(selectedTab: tab)
            })
            .disposed(by: disposeBag)
    }
    
    func update(selectedTab: TabView.Tab) {
        coordinator.change(tab: selectedTab)
    }
}
