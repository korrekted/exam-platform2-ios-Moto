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
            .courseName
            .drive(onNext: { name in
                AmplitudeManager.shared
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
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(PaygateViewController.make(), animated: true)
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

// MARK: Private
private extension StatsViewController {
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
        let empty = mainView.tableView.elements.isEmpty
        
        let inProgress = empty && activity
        
        inProgress ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
