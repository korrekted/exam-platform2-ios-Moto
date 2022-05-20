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
        SDKStorage.shared.amplitudeManager.logEvent(name: "Flashcards Sets Screen", parameters: [:])
        
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
                    SDKStorage.shared.amplitudeManager.logEvent(name: "Flashcards Sets Tap", parameters: ["what": "flashcard set"])
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
        let empty = mainView.tableView.flashcards.isEmpty
        
        let inProgress = empty && activity
        
        inProgress ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    @objc
    func popAction() {
        SDKStorage.shared.amplitudeManager.logEvent(name: "Flashcards Set Tap", parameters: ["what": "back"])
        navigationController?.popViewController(animated: true)
    }
}
