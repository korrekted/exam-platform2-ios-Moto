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
        
        viewModel
            .course
            .map { $0.name }
            .drive(onNext: { name in
                AmplitudeManager.shared
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
            .withLatestFrom(viewModel.course)
            .bind(to: Binder(self) { base, course in
                base.openTest(types: [.get(testId: nil)], course: course)
                
                AmplitudeManager.shared
                    .logEvent(name: "Study Tap", parameters: ["what": "take a free test"])
            })
            .disposed(by: disposeBag)
        
        mainView.unlockButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.openPaygate()
                
                AmplitudeManager.shared
                    .logEvent(name: "Study Tap", parameters: ["what": "unlock all questions"])
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView
            .selectedMode
            .withLatestFrom(viewModel.course) { ($0, $1) }
            .bind(to: Binder(self) { base, tuple in
                let (mode, course) = tuple
                base.tapped(mode: mode, course: course)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.didTapFlashcards
            .withLatestFrom(viewModel.course)
            .asSignal(onErrorSignalWith: .never())
            .emit(onNext: { [weak self] course in
                self?.navigationController?.pushViewController(FlashcardsTopicsViewController.make(courseId: course.id), animated: true)
                AmplitudeManager.shared.logEvent(name: "Study tap", parameters: ["what": "flashcards"])
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.didTapTrophy
            .asSignal()
            .emit(onNext: {
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(PaygateViewController.make(), animated: true)
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
        
        AmplitudeManager.shared
            .logEvent(name: "Study Tap", parameters: ["what": "settings"])
    }
    
    func tapped(mode: SCEMode.Mode, course: Course) {
        switch mode {
        case .ten:
            openTest(types: [.tenSet], course: course)
            
            AmplitudeManager.shared
                .logEvent(name: "Study Tap", parameters: ["what": "10 questions"])
        case .random:
            openTest(types: [.randomSet], course: course)
            
            AmplitudeManager.shared
                .logEvent(name: "Study Tap", parameters: ["what": "random set"])
        case .missed:
            openTest(types: [.failedSet], course: course)
            
            AmplitudeManager.shared
                .logEvent(name: "Study Tap", parameters: ["what": "missed questions"])
        case .today:
            openTest(types: [.qotd], course: course)
            
            AmplitudeManager.shared
                .logEvent(name: "Study Tap", parameters: ["what": "question of the day"])
        case .time:
            let controller = TimedExamViewController.make() { [weak self] minutes in
                self?.openTest(types: [.timed(minutes: minutes)], course: course)
            }
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = self
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(controller, animated: true)
        }
    }
    
    func openTest(types: [TestType], course: Course) {
        TestCoordinator.shared.start(testTypes: types, course: course, isTopicTest: false, from: self)
    }
    
    func openCourseDetails(course: Course) {
        let controller = CourseDetailsViewController.make(course: course)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openPaygate() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(PaygateViewController.make(), animated: true)
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
    
    func activity(_ activity: Bool) {
        let empty = mainView.collectionView.sections.isEmpty
        
        let inProgress = empty && activity
        
        inProgress ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
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
