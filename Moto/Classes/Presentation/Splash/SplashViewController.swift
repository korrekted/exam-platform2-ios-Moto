//
//  SplashViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController {
    lazy var mainView = SplashView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = SplashViewModel()
    
    private let generateStep: Signal<Void>
    
    private init(generateStep: Signal<Void>) {
        self.generateStep = generateStep
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateStep
            .delay(RxTimeInterval.seconds(1))
            .flatMap { [weak self] in
                self?.viewModel.step() ?? .empty()
            }
            .drive(onNext: step(_:))
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SplashViewController {
    static func make(generateStep: Signal<Void>) -> SplashViewController {
        SplashViewController(generateStep: generateStep)
    }
}

// MARK: PaygateViewControllerDelegate
extension SplashViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        step(viewModel.stepAfterPaygateClosed())
    }
}

// MARK: Private
private extension SplashViewController {
    func step(_ step: SplashViewModel.Step) {
        switch step {
        case .onboarding:
            UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController.make()
        case .course:
            UIApplication.shared.keyWindow?.rootViewController = CourseViewController.make()
        case .paygate:
            let vc = PaygateViewController.make()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
}
