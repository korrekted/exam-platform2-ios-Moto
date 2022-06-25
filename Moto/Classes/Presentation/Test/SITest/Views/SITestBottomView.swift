//
//  SITestBottomView.swift
//  CDL
//
//  Created by Андрей Чернышев on 23.06.2022.
//

import UIKit

final class SITestBottomView: GradientView {
    enum State {
        case confirm, next, finish, hidden
    }
    
    lazy var button = makeButton()
    lazy var preloader = makePreloader()
    
    private lazy var buttonWidthConstraint = NSLayoutConstraint()
    private lazy var buttonHeightConstraint = NSLayoutConstraint()
    private lazy var buttonTrailingConstraint = NSLayoutConstraint()
    private lazy var buttonTopConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if button.isHidden {
            return false
        }
        
        return button.frame.contains(point)
    }
}

// MARK: Public
extension SITestBottomView {
    func setup(state: SITestBottomView.State) {
        switch state {
        case .confirm:
            setupFullButton(text: "Question.Continue".localized)
        case .next:
            setupNextButton()
        case .finish:
            setupFullButton(text: "Question.Finish".localized)
        case .hidden:
            button.isHidden = true
        }
        
        bringSubviewToFront(preloader)
    }
}

// MARK: Private
private extension SITestBottomView {
    func initialize() {
        gradientLayer.colors = [
            UIColor(integralRed: 245, green: 245, blue: 245, alpha: 0).cgColor,
            UIColor(integralRed: 245, green: 245, blue: 245, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0, 0.5]
    }
    
    func setupFullButton(text: String) {
        button.isHidden = false
        
        NSLayoutConstraint.deactivate([
            buttonWidthConstraint,
            buttonHeightConstraint,
            buttonTrailingConstraint,
            buttonTopConstraint
        ])
        
        buttonWidthConstraint = button.widthAnchor.constraint(equalToConstant: 343.scale)
        buttonHeightConstraint = button.heightAnchor.constraint(equalToConstant: 53.scale)
        buttonTrailingConstraint = button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        buttonTopConstraint = button.topAnchor.constraint(equalTo: topAnchor, constant: 65.scale)
        
        NSLayoutConstraint.activate([
            buttonWidthConstraint,
            buttonHeightConstraint,
            buttonTrailingConstraint,
            buttonTopConstraint
        ])
        
        let attrs = TextAttributes()
            .font(Fonts.Lato.bold(size: 18.scale))
            .textColor(TestPalette.primaryTint)
            .textAlignment(.center)
        button.setAttributedTitle(text.attributed(with: attrs), for: .normal)
        
        button.backgroundColor = TestPalette.primaryButton
        button.layer.cornerRadius = 12.scale
        button.setImage(nil, for: .normal)
        button.tintColor = UIColor.clear
        
        button.layoutIfNeeded()
    }
    
    func setupNextButton() {
        button.isHidden = false
        
        NSLayoutConstraint.deactivate([
            buttonWidthConstraint,
            buttonHeightConstraint,
            buttonTrailingConstraint,
            buttonTopConstraint
        ])
        
        buttonWidthConstraint = button.widthAnchor.constraint(equalToConstant: 40.scale)
        buttonHeightConstraint = button.heightAnchor.constraint(equalToConstant: 40.scale)
        buttonTrailingConstraint = button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale)
        buttonTopConstraint = button.topAnchor.constraint(equalTo: topAnchor, constant: 70.scale)
        
        NSLayoutConstraint.activate([
            buttonWidthConstraint,
            buttonHeightConstraint,
            buttonTrailingConstraint,
            buttonTopConstraint
        ])
        
        button.setAttributedTitle(nil, for: .normal)
        button.backgroundColor = TestPalette.secondaryButton
        button.layer.cornerRadius = 7.scale
        button.setImage(UIImage(named: "Question.Next"), for: .normal)
        button.tintColor = TestPalette.secondaryTint
        
        button.layoutIfNeeded()
    }
}

// MARK: Make constraints
private extension SITestBottomView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 343.scale),
            preloader.heightAnchor.constraint(equalToConstant: 53.scale),
            preloader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            preloader.topAnchor.constraint(equalTo: topAnchor, constant: 65.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SITestBottomView {
    func makeButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> TestBottomSpinner {
        let view = TestBottomSpinner()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = TestPalette.primaryButton
        view.stop()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

