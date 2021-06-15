//
//  OSlideView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 23.01.2021.
//

import UIKit

protocol OSlideViewDelegate: AnyObject {
    func slideViewDidNext(from step: OnboardingView.Step)
}

class OSlideView: UIView {
    let step: OnboardingView.Step
    
    weak var delegate: OSlideViewDelegate?
    var didNextTapped: ((OnboardingView.Step) -> Void)?
    
    init(step: OnboardingView.Step) {
        self.step = step
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToThis() {}
    
    @objc
    func onNext() {
        delegate?.slideViewDidNext(from: step)
        didNextTapped?(step)
    }
}
