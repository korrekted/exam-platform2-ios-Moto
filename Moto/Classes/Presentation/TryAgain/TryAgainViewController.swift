//
//  TryAgainViewController.swift
//  Moto
//
//  Created by Андрей Чернышев on 20.05.2022.
//

import UIKit
import RxSwift

protocol TryAgainViewControllerDelegate: AnyObject {
    func tryAgainDidTapped()
}

final class TryAgainViewController: UIViewController {
    weak var delegate: TryAgainViewControllerDelegate?
    
    lazy var mainView = TryAgainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let tryAgain: (() -> Void)?
    
    private init(tryAgain: (() -> Void)?) {
        self.tryAgain = tryAgain
        
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
        
        mainView.tryAgainButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.dismiss(animated: true) {
                    self.delegate?.tryAgainDidTapped()
                    self.tryAgain?()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.contactButton.rx.tap
            .subscribe(onNext: {
                guard let url = URL(string: GlobalDefinitions.contactUsUrl) else {
                    return
                }
                
                UIApplication.shared.open(url, options: [:])
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TryAgainViewController {
    static func make(tryAgain: (() -> Void)? = nil) -> TryAgainViewController {
        TryAgainViewController(tryAgain: tryAgain)
    }
}
