//
//  OSlideQuestionView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideQuestionView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var questionLabel = makeQuestionLabel()
    lazy var yesButton = makeYesButton()
    lazy var noButton = makeNoButton()

    private let questionKey: String
    
    init(step: OnboardingView.Step, questionKey: String) {
        self.questionKey = questionKey
        
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OSlideQuestionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: questionLabel.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: yesButton.topAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            noButton.widthAnchor.constraint(equalToConstant: 165.scale),
            noButton.heightAnchor.constraint(equalToConstant: 60.scale),
            noButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            noButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            yesButton.widthAnchor.constraint(equalToConstant: 165.scale),
            yesButton.heightAnchor.constraint(equalToConstant: 60.scale),
            yesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            yesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideQuestionView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.bold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Question.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeQuestionLabel() -> OQuestionFormView {
        let attrs = TextAttributes()
            .textColor(Onboarding.Question.text)
            .font(Fonts.SFProRounded.regular(size: 20.scale))
            .lineHeight(28.scale)
            .textAlignment(.center)
        
        let view = OQuestionFormView()
        view.label.attributedText = questionKey.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeYesButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(Onboarding.primaryButtonTint)
        
        let view = UIButton()
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.Yes".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Onboarding.primaryButton
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNoButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(Onboarding.secondaryButtonTint)
        
        let view = UIButton()
        view.layer.cornerRadius = 30.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Onboarding.secondaryButtonBorder.cgColor
        view.setAttributedTitle("Onboarding.No".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Onboarding.secondaryButton
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
