//
//  TimedExamViewController.swift
//  DMV
//
//  Created by Vitaliy Zagorodnov on 02.06.2021.
//

import UIKit
import RxSwift

final class TimedExamViewController: UIViewController {
    lazy var mainView = TimedExamView()
    
    private lazy var disposeBag = DisposeBag()
    
    private var didTapStart: ((Int) -> Void)?
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.startButton.rx.tap
            .withLatestFrom(mainView.slider.rx.value)
            .map { Int($0) }
            .subscribe(onNext: { [weak self] value in
                self?.dismiss(animated: true) {
                    self?.didTapStart?(value)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TimedExamViewController {
    static func make(didTapStart: @escaping (Int) -> Void) -> TimedExamViewController {
        let controller = TimedExamViewController()
        controller.didTapStart = didTapStart
        return controller
    }
}
