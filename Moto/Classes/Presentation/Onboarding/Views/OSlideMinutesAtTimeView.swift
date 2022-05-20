//
//  OSlideMinutesAtTimeView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 28.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class OSlideMinutesAtTimeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(element: MinutesAtTimeElement(title: "Onboarding.MinutesAtTime.Casual".localized,
                                                            subTitle: "Onboarding.MinutesAtTime.5min".localized,
                                                            minutes: 5))
    lazy var cell2 = makeCell(element: MinutesAtTimeElement(title: "Onboarding.MinutesAtTime.Regular".localized,
                                                            subTitle: "Onboarding.MinutesAtTime.10min".localized,
                                                            minutes: 10))
    lazy var cell3 = makeCell(element: MinutesAtTimeElement(title: "Onboarding.MinutesAtTime.Serious".localized,
                                                            subTitle: "Onboarding.MinutesAtTime.15min".localized,
                                                            minutes: 15))
    lazy var cell4 = makeCell(element: MinutesAtTimeElement(title: "Onboarding.MinutesAtTime.Intense".localized,
                                                            subTitle: "Onboarding.MinutesAtTime.20min".localized,
                                                            minutes: 20))
    lazy var button = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
        changeEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideMinutesAtTimeView {
    func initialize() {
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                guard
                    let selected = [self.cell1, self.cell2, self.cell3, self.cell4]
                        .first(where: { $0.isSelected })?
                        .element
                else {
                    return
                }
                
                self.scope.testMinutes = selected.minutes

                self.onNext()
            })
            .disposed(by: disposeBag)
        
        cell1.layer.cornerRadius = 12.scale
        cell1.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        cell4.layer.cornerRadius = 12.scale
        cell4.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @objc
    func selected(tapGesture: UITapGestureRecognizer) {
        guard let cell = tapGesture.view as? OMinutesAtTimeCell else {
            return
        }
        
        [cell1, cell2, cell3, cell4].forEach { $0.isSelected = false }
        
        cell.isSelected = true
        
        changeEnabled()
    }
    
    func changeEnabled() {
        let isEmpty = [
            cell1, cell2, cell3, cell4
        ]
        .filter { $0.isSelected }
        .isEmpty
        
        button.isEnabled = !isEmpty
        button.alpha = isEmpty ? 0.4 : 1
    }
}

// MARK: Make constraints
private extension OSlideMinutesAtTimeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: cell1.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell1.bottomAnchor.constraint(equalTo: cell2.topAnchor),
            cell1.heightAnchor.constraint(equalToConstant: 57.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell2.bottomAnchor.constraint(equalTo: cell3.topAnchor),
            cell2.heightAnchor.constraint(equalToConstant: 57.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell3.bottomAnchor.constraint(equalTo: cell4.topAnchor),
            cell3.heightAnchor.constraint(equalToConstant: 57.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell4.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale),
            cell4.heightAnchor.constraint(equalToConstant: 57.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideMinutesAtTimeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.semiBold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.MinutesAtTime.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(element: MinutesAtTimeElement) -> OMinutesAtTimeCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selected(tapGesture:)))
        
        let view = OMinutesAtTimeCell()
        view.element = element
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryButtonTint)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Onboarding.primaryButton
        view.layer.cornerRadius = 20.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
