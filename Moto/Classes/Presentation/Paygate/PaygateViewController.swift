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
    private enum Scene {
        case not, main, specialOffer
    }
    
    var paygateView = PaygateView()
    
    weak var delegate: PaygateViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    
    private var currentScene = Scene.not
    
    private let viewModel = PaygateViewModel()
    
    deinit {
        paygateView.specialOfferView.stopTimer()
    }
    
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
        
        viewModel.monetizationConfig()
            .drive(onNext: { [weak self] config in
                self?.retrieve(config: config)
            })
            .disposed(by: disposeBag)
        
        let retrieved = viewModel.retrieve()
        
        retrieved
            .drive(onNext: { [weak self] paygate, completed in
                guard let `self` = self, let paygate = paygate else {
                    return
                }
                
                if paygate.main != nil {
                    self.animateShowMainContent()
                } else {
                    if paygate.specialOffer != nil {
                        self.animateMoveToSpecialOfferView()
                    }
                }
                
                if let main = paygate.main {
                    self.paygateView.mainView.setup(paygate: main)
                }
                
                if let specialOffer = paygate.specialOffer {
                    self.paygateView.specialOfferView.setup(paygate: specialOffer)
                }
                
                if completed {
                    if paygate.main != nil {
                        self.currentScene = .main
                    } else if paygate.main == nil && paygate.specialOffer != nil {
                        self.currentScene = .specialOffer
                    }
                }
            })
            .disposed(by: disposeBag)
        
        let paygate = retrieved
            .map { $0.0 }
            .startWith(nil)
        
        paygateView
            .mainView
            .closeButton.rx.tap
            .withLatestFrom(paygate)
            .subscribe(onNext: { [unowned self] paygate in
                switch self.currentScene {
                case .not:
                    self.dismiss(with: .cancelled)
                case .main:
                    if paygate?.specialOffer != nil {
                        self.animateMoveToSpecialOfferView()
                        self.currentScene = .specialOffer
                    } else {
                        self.dismiss(with: .cancelled)
                    }
                case .specialOffer:
                    self.paygateView.specialOfferView.stopTimer()
                    self.dismiss(with: .cancelled)
                }
            })
            .disposed(by: disposeBag)
        
        paygateView
            .mainView
            .continueButton.rx.tap
            .subscribe(onNext: { [unowned self] productId in
                guard let productId = [self.paygateView.mainView.leftOptionView, self.paygateView.mainView.rightOptionView]
                    .first(where: { $0.isSelected })?
                    .productId
                else {
                    return
                }
                
                self.viewModel.buy.accept(productId)
            })
            .disposed(by: disposeBag)
        
        paygateView
            .mainView
            .restoreButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                guard let productId = [self.paygateView.mainView.leftOptionView, self.paygateView.mainView.rightOptionView]
                    .first(where: { $0.isSelected })?
                    .productId
                else {
                    return
                }
                
                self.viewModel.restore.accept(productId)
            })
            .disposed(by: disposeBag)
        
        paygateView
            .specialOfferView
            .continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let productId = self?.paygateView.specialOfferView.specialOffer?.productId else {
                    return
                }
                
                self?.viewModel.buy.accept(productId)
            })
            .disposed(by: disposeBag)
        
        paygateView
            .specialOfferView
            .restoreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let productId = self?.paygateView.specialOfferView.specialOffer?.productId else {
                    return
                }
                
                self?.viewModel.restore.accept(productId)
            })
            .disposed(by: disposeBag)
        
        Driver
            .merge(viewModel.buyProcessing.asDriver(),
                   viewModel.restoreProcessing.asDriver(),
                   viewModel.retrieveCompleted.asDriver(onErrorJustReturn: true).map { !$0 })
            .drive(onNext: { [weak self] isLoading in
                self?.paygateView.mainView.continueButton.isHidden = isLoading
                self?.paygateView.mainView.restoreButton.isHidden = isLoading
                self?.paygateView.specialOfferView.continueButton.isHidden = isLoading
                self?.paygateView.specialOfferView.restoreButton.isHidden = isLoading

                isLoading ? self?.paygateView.mainView.purchasePreloaderView.startAnimating() : self?.paygateView.mainView.purchasePreloaderView.stopAnimating()
                isLoading ? self?.paygateView.specialOfferView.purchasePreloaderView.startAnimating() : self?.paygateView.specialOfferView.purchasePreloaderView.stopAnimating()
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
    func retrieve(config: PaygateViewModel.Config) {
        switch config {
        case .block:
            paygateView.mainView.closeButton.isHidden = true
        case .suggest:
            paygateView.mainView.closeButton.isHidden = false
        }
    }
    
    func addMainOptionsSelection() {
        let leftOptionTapGesture = UITapGestureRecognizer()
        paygateView.mainView.leftOptionView.addGestureRecognizer(leftOptionTapGesture)
        
        leftOptionTapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                if let productId = self.paygateView.mainView.leftOptionView.productId {
                    self.viewModel.buy.accept(productId)
                }
                
                guard !self.paygateView.mainView.leftOptionView.isSelected else {
                    return
                }
                
                self.paygateView.mainView.leftOptionView.isSelected = true
                self.paygateView.mainView.rightOptionView.isSelected = false
            })
            .disposed(by: disposeBag)
        
        let rightOptionTapGesture = UITapGestureRecognizer()
        paygateView.mainView.rightOptionView.addGestureRecognizer(rightOptionTapGesture)
        
        rightOptionTapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                if let productId = self.paygateView.mainView.rightOptionView.productId {
                    self.viewModel.buy.accept(productId)
                }
                
                guard !self.paygateView.mainView.rightOptionView.isSelected else {
                    return
                }
                
                self.paygateView.mainView.leftOptionView.isSelected = false
                self.paygateView.mainView.rightOptionView.isSelected = true
            })
            .disposed(by: disposeBag)
    }
    
    func animateShowMainContent() {
        paygateView.mainView.isHidden = false
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.paygateView.mainView.leftOptionView.alpha = 1
            self?.paygateView.mainView.rightOptionView.alpha = 1
        })
    }
    
    func animateMoveToSpecialOfferView() {
        paygateView.specialOfferView.isHidden = false
        paygateView.specialOfferView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.paygateView.mainView.alpha = 0
            self?.paygateView.specialOfferView.alpha = 1
        }, completion: { [weak self] _ in
            self?.paygateView.specialOfferView.startTimer()
        })
    }
    
    func dismiss(with result: PaygateViewControllerResult) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.paygateDidClosed(with: result)
        }
    }
}
