//
//  FlashcardsViewController.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import UIKit
import RxSwift

final class FlashcardsTopicsViewController: UIViewController {
    lazy var mainView = FlashcardsTopicsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = FlashcardsTopicsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.flashcardsTopics
            .drive(onNext: { [weak self] flashcardsTopics in
                self?.mainView.tableView.setup(flashcards: flashcardsTopics)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.didTappedRelay
            .withLatestFrom(viewModel.activeSubscription) { ($0, $1) }
            .subscribe(onNext: { [weak self] stub in
                let (topic, activeSubscription) = stub
                
                if topic.paid && !activeSubscription {
                    UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
                } else {
                    let vc = FlashcardsViewController.make(topic: topic)
                    self?.parent?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.navigationView.leftAction.addTarget(self, action: #selector(popAction), for: .touchUpInside)
    }
}

// MARK: Make
extension FlashcardsTopicsViewController {
    static func make(courseId: Int) -> FlashcardsTopicsViewController {
        let vc = FlashcardsTopicsViewController()
        vc.viewModel.courseId.accept(courseId)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension FlashcardsTopicsViewController {
    @objc
    func popAction() {
        navigationController?.popViewController(animated: true)
    }
}
