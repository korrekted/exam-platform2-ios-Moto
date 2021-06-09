//
//  PaygateViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PaygateViewController: UIViewController {
    lazy var paygateView = PaygateView()
    
    weak var delegate: PaygateViewControllerDelegate?
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = PaygateViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = paygateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Paygate Screen", parameters: [:])

        addMainOptionsSelection()

        viewModel.paygate
            .drive(onNext: { [weak self] paygate in
                if let paygate = paygate {
                    self?.paygateView.scrollView.setup(paygate: paygate)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.config
            .drive(onNext: { [weak self] config in
                self?.paygateView.scrollView.setup(config: config)
                self?.hideIndicatorsIfNeeded(config: config)
            })
            .disposed(by: disposeBag)
        
        paygateView.scrollView
            .freeView.continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(with: .cancelled)
            })
            .disposed(by: disposeBag)

        paygateView
            .scrollView.paidView
            .continueButton.rx.tap
            .subscribe(onNext: { [unowned self] productId in
                guard let productId = [self.paygateView.scrollView.paidView.option1View,
                                       self.paygateView.scrollView.paidView.option2View]
                    .first(where: { $0.isSelected })?
                    .productId
                else {
                    return
                }

                self.viewModel.buy.accept(productId)
            })
            .disposed(by: disposeBag)

        paygateView.restoreButton.rx.tap
            .bind(to: viewModel.restore)
            .disposed(by: disposeBag)

        viewModel.processing
            .drive(onNext: { [weak self] isLoading in
                self?.paygateView.scrollView.paidView.continueButton.isHidden = isLoading
                self?.paygateView.restoreButton.isHidden = isLoading
                self?.paygateView.scrollView.paidView.inProgress(isLoading)
            })
            .disposed(by: disposeBag)

        viewModel
            .buyed
            .emit(onNext: { [weak self] result in
                if !result {
                    Toast.notify(with: "Paygate.Purchase.Failed".localized, style: .danger)
                    return
                }

                self?.dismiss(with: .bied)
            })
            .disposed(by: disposeBag)

        viewModel
            .restored
            .emit(onNext: { [weak self] result in
                if !result {
                    Toast.notify(with: "Paygate.Purchase.Failed".localized, style: .danger)
                    return
                }

                self?.dismiss(with: .restored)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension PaygateViewController {
    static func make() -> PaygateViewController {
        let vc = PaygateViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        return vc
    }
}

// MARK: Private
private extension PaygateViewController {
    func hideIndicatorsIfNeeded(config: PaygateViewModel.Config) {
        switch config {
        case .block:
            paygateView.indicatorsView.isHidden = true
        case .suggest:
            paygateView.indicatorsView.isHidden = false
        }
    }
    
    func addMainOptionsSelection() {
        let paidView = paygateView.scrollView.paidView
        
        let option1TapGesture = UITapGestureRecognizer()
        paidView.option1View.addGestureRecognizer(option1TapGesture)

        option1TapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                if let productId = paidView.option1View.productId {
                    self.viewModel.buy.accept(productId)
                }

                guard !paidView.option1View.isSelected else {
                    return
                }

                paidView.option1View.isSelected = true
                paidView.option2View.isSelected = false
            })
            .disposed(by: disposeBag)

        let option2TapGesture = UITapGestureRecognizer()
        paidView.option2View.addGestureRecognizer(option2TapGesture)

        option2TapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                if let productId = paidView.option2View.productId {
                    self.viewModel.buy.accept(productId)
                }

                guard !paidView.option2View.isSelected else {
                    return
                }

                paidView.option1View.isSelected = false
                paidView.option2View.isSelected = true
            })
            .disposed(by: disposeBag)
    }
    
    func dismiss(with result: PaygateViewControllerResult) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.paygateDidClosed(with: result)
        }
    }
}
