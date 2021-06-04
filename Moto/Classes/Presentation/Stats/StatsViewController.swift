//
//  StatsViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class StatsViewController: UIViewController {
    private lazy var mainView = StatsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = StatsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .courseName
            .drive(onNext: { name in
                SDKStorage.shared
                    .amplitudeManager
                    .logEvent(name: "Stats Screen", parameters: ["course": ""])
            })
            .disposed(by: disposeBag)
        
        viewModel
            .elements
            .drive(onNext: { [mainView] elements in
                mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        viewModel.passRate
            .drive(Binder(mainView.progressView) {
                $0.setProgress(percent: $1)
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
extension StatsViewController {
    static func make() -> StatsViewController {
        StatsViewController()
    }
}
