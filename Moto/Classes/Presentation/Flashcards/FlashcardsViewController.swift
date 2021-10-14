//
//  FlashcardsViewController.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import UIKit
import RxSwift

final class FlashcardsViewController: UIViewController {
    lazy var mainView = FlashcardsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = FlashcardsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.flashcards
            .drive(Binder(mainView) {
                $0.flashCardContainer.showCards(for: $1)
            })
            .disposed(by: disposeBag)
        
        mainView.flashCardContainer
            .selectedAnswer
            .bind(to: viewModel.selectedAnswer)
            .disposed(by: disposeBag)
        
        let leftAction = mainView.navigationView.leftAction.rx.tap
            .asObservable()
            .do(onNext: {
                SDKStorage.shared.amplitudeManager.logEvent(name: "Flashcards Tap", parameters: ["what": "back"])
            })
        
        Observable
            .merge(
                leftAction,
                mainView.flashCardContainer.finish
            )
            .bind(to: Binder(self) { base, _ in
                FlashCardManagerMediator.shared.finishFlashCards()
                base.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.mark
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension FlashcardsViewController {
    static func make(topic: FlashcardTopic) -> FlashcardsViewController {
        let vc = FlashcardsViewController()
        vc.viewModel.flashcardTopicId.accept(topic.id)
        vc.mainView.navigationView.setTitle(title: topic.name)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

