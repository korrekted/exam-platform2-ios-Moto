//
//  SettingsViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import RxSwift

final class SettingsViewController: UIViewController {
    lazy var mainView = SettingsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = SettingsViewModel()
    private lazy var screenOpener = SettingsOpener()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navigationView.leftAction.addTarget(self, action: #selector(popAction), for: .touchUpInside)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Settings Screen", parameters: [:])
        
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
            .sections
            .drive(onNext: mainView.tableView.setup(sections:))
            .disposed(by: disposeBag)
        
        mainView
            .tableView.tapped
            .subscribe(onNext: tapped(_:))
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SettingsViewController {
    static func make() -> SettingsViewController {
        SettingsViewController()
    }
}

// MARK: Private
private extension SettingsViewController {
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
        let empty = mainView.tableView.sections.isEmpty
        
        let inProgress = empty && activity
        
        inProgress ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func tapped(_ tapped: SettingsTableView.Tapped) {
        switch tapped {
        case .unlock:
            UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Settings Tap", parameters: ["what": "unlock premium"])
        case .rateUs:
            RateUs.requestReview()
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Settings Tap", parameters: ["what": "rate us"])
        case .contactUs:
            open(path: GlobalDefinitions.contactUsUrl)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Settings Tap", parameters: ["what": "contact us"])
        case .termsOfUse:
            open(path: GlobalDefinitions.termsOfServiceUrl)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Settings Tap", parameters: ["what": "terms of use"])
        case .privacyPoliicy:
            open(path: GlobalDefinitions.privacyPolicyUrl)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Settings Tap", parameters: ["what": "privacy policy"])
        case .locale:
            screenOpener.open(screen: .locale, from: self)
        case .mode(let mode):
            screenOpener.open(screen: .mode(mode), from: self)
        }
    }
    
    func open(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    @objc func popAction() {
        navigationController?.popViewController(animated: true)
    }
}
