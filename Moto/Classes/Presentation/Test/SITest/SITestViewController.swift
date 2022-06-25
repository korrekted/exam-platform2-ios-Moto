//
//  SITestViewController.swift
//  CDL
//
//  Created by Андрей Чернышев on 23.06.2022.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit
import RushSDK

final class SITestViewController: UIViewController {
    lazy var mainView = SITestView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: SITestViewModel
    
    init(course: Course, testType: SITestType) {
        self.viewModel = SITestViewModel(course: course, testType: testType)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .empty()
            }

            return self.openError()
        }

        viewModel.loadTestActivityIndicator
            .drive(Binder(self) { base, activity in
                activity ? base.mainView.preloader.startAnimating() : base.mainView.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)

        viewModel.sendAnswerActivityIndicator
            .drive(Binder(mainView.bottomView.preloader) { base, activity in
                activity ? base.start() : base.stop()
            })
            .disposed(by: disposeBag)
        
        viewModel.questionProgress
            .drive(Binder(mainView.collectionView) {
                $0.setup(elements: $1)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView
            .selectedIndex
            .bind(to: viewModel.didTapIndexQuestion)
            .disposed(by: disposeBag)

        mainView.navigationView.rightAction.rx.tap
            .withLatestFrom(viewModel.isSavedQuestion)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)

        viewModel.isSavedQuestion
            .drive(Binder(self) { base, isSaved in
                base.update(favorite: isSaved)
            })
            .disposed(by: disposeBag)

        viewModel.question
            .drive(Binder(self) { base, element in
                base.mainView.tableView.setup(question: element)
            })
            .disposed(by: disposeBag)

        mainView.tableView
            .selectedAnswersRelay
            .bind(to: viewModel.answers)
            .disposed(by: disposeBag)

        viewModel.bottomViewState
            .startWith(.hidden)
            .drive(Binder(mainView.bottomView) {
                $0.setup(state: $1)
            })
            .disposed(by: disposeBag)

        let currentButtonState = mainView.bottomView.button.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .share()

        currentButtonState
            .compactMap { $0 == .confirm ? () : nil }
            .bind(to: viewModel.didTapConfirm)
            .disposed(by: disposeBag)

        currentButtonState
            .compactMap { $0 == .next ? () : nil }
            .bind(to: viewModel.didTapNext)
            .disposed(by: disposeBag)
        
        currentButtonState
            .compactMap { $0 == .finish ? () : nil }
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.isEndOfTest
            .filter(!)
            .withLatestFrom(viewModel.testMode)
            .bind(with: self, onNext: { base, testMode in
                if testMode == .onAnExam {
                    base.viewModel.didTapNext.accept(Void())
                }
            })
            .disposed(by: disposeBag)

        mainView.tableView.expandContent
            .bind(to: Binder(self) { base, content in
                switch content {
                case let .image(url):
                    let controller = PhotoViewController.make(imageURL: url)
                    base.present(controller, animated: true)
                case let .video(url):
                    let controller = AVPlayerViewController()
                    controller.view.backgroundColor = .black
                    let player = AVPlayer(url: url)
                    controller.player = player
                    base.present(controller, animated: true) { [weak player] in
                        player?.play()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        mainView.navigationView.leftAction.rx.tap
            .bind(to: Binder(self) { base, void in
                SITestCloseMediator.shared.notifyAboudTestClosed()
                
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SITestViewController {
    static func make(course: Course, testType: SITestType) -> SITestViewController {
        let controller = SITestViewController(course: course, testType: testType)
        controller.modalPresentationStyle = .fullScreen
        controller.mainView.navigationView.setTitle(title: testType.name)
        controller.mainView.navigationView.rightAction.isHidden = testType == .incorrect
        return controller
    }
}

// MARK: Private
private extension SITestViewController {
    func update(favorite: Bool) {
        let image = favorite ? UIImage(named: "Question.Bookmark.Check") : UIImage(named: "Question.Bookmark.Uncheck")
        mainView.navigationView.rightAction.setImage(image, for: .normal)
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
}
