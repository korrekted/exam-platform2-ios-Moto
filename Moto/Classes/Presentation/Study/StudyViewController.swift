//
//  StudyViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class StudyViewController: UIViewController {
    lazy var mainView = StudyView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = StudyViewModel()
    
    private lazy var opener = SettingsOpener()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let activeSubscription = viewModel.activeSubscription
        
        viewModel
            .course
            .map { $0.name }
            .drive(onNext: { name in
                SDKStorage.shared
                    .amplitudeManager
                    .logEvent(name: "Study Screen", parameters: ["exam": name])
            })
            .disposed(by: disposeBag)
        
        viewModel
            .sections
            .drive(onNext: { [weak self] sections in
                self?.mainView.collectionView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        viewModel.activeSubscription
            .drive(Binder(mainView) {
                $0.setupButtons($1)
            })
            .disposed(by: disposeBag)
        
        mainView
            .navigationView.rightAction.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.settingsTapped()
            })
            .disposed(by: disposeBag)
        
        viewModel.brief
            .drive(Binder(mainView) {
                $0.setup(brief: $1)
            })
            .disposed(by: disposeBag)
        
        mainView.takeButton.rx.tap
            .withLatestFrom(viewModel.activeSubscription)
            .withLatestFrom(viewModel.course) { ($0, $1) }
            .bind(to: Binder(self) { base, tuple in
                let (activeSubscription, course) = tuple
                
                base.openTest(type: .get(testId: nil), activeSubscription: activeSubscription, courseId: course.id)
                
                SDKStorage.shared
                    .amplitudeManager
                    .logEvent(name: "Study Tap", parameters: ["what": "take a free test"])
            })
            .disposed(by: disposeBag)
        
        mainView.unlockButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.openPaygate()
                
                SDKStorage.shared
                    .amplitudeManager
                    .logEvent(name: "Study Tap", parameters: ["what": "unlock all questions"])
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView
            .selectedMode
            .withLatestFrom(activeSubscription) { ($0, $1) }
            .withLatestFrom(viewModel.course) { ($0.0, $0.1, $1) }
            .bind(to: Binder(self) { base, tuple in
                let (mode, activeSubscription, course) = tuple
                base.tapped(mode: mode, activeSubscription: activeSubscription, courseId: course.id)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.didTapTrophy
            .asSignal()
            .emit(onNext: {
                UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.didTapFlashcards
            .withLatestFrom(viewModel.course)
            .asSignal(onErrorSignalWith: .never())
            .emit(onNext: { [weak self] course in
                self?.navigationController?.pushViewController(FlashcardsTopicsViewController.make(courseId: course.id), animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView
            .selectedCourse
            .bind(to: viewModel.selectedCourse)
            .disposed(by: disposeBag)
        
        mainView.collectionView
            .didTapSelectedCourse.bind(to: Binder(self) {
                $0.openCourseDetails(course: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.finishedTimedTest
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension StudyViewController {
    static func make() -> StudyViewController {
        let vc = StudyViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension StudyViewController {
    func settingsTapped() {
        navigationController?.pushViewController(SettingsViewController.make(), animated: true)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Study Tap", parameters: ["what": "settings"])
    }
    
    func tapped(mode: SCEMode.Mode, activeSubscription: Bool, courseId: Int) {
        switch mode {
        case .ten:
            openTest(type: .tenSet, activeSubscription: activeSubscription, courseId: courseId)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "10 questions"])
        case .random:
            openTest(type: .randomSet, activeSubscription: activeSubscription, courseId: courseId)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "random set"])
        case .missed:
            openTest(type: .failedSet, activeSubscription: activeSubscription, courseId: courseId)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "missed questions"])
        case .today:
            openTest(type: .qotd, activeSubscription: activeSubscription, courseId: courseId)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "question of the day"])
        case .time:
            let controller = TimedExamViewController.make() { [weak self] minutes in
                self?.openTest(type: .timedQuizz(minutes: minutes), activeSubscription: activeSubscription, courseId: courseId)
            }
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true)
        }
    }
    
    func openTest(type: TestType, activeSubscription: Bool, courseId: Int) {
             let controller = TestViewController.make(testType: type, activeSubscription: activeSubscription, courseId: courseId, isTopicTest: false)
        parent?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openCourseDetails(course: Course) {
        let controller = CourseDetailsViewController.make(course: course)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openPaygate() {
        UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
    }
}

extension StudyViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimation(duration: 0.5, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimation(duration: 0.5, animationType: .dismiss)
    }
}
