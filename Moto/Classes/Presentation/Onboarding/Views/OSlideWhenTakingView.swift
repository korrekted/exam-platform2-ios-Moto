//
//  OSlide5View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class OSlideWhenTakingView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var datePickerView = makeDatePickerView()
    lazy var cursorView = makeCursorView()
    lazy var button = makeButton()
    lazy var dontKnowButton = makeDontNowButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideWhenTakingView {
    func initialize() {
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                let date = self.datePickerView.date
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                
                let examDate = formatter.string(from: date)
                
                self.scope.examDate = examDate

                self.onNext()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension OSlideWhenTakingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: datePickerView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            datePickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePickerView.heightAnchor.constraint(equalToConstant: 229.scale),
            datePickerView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            cursorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14.scale),
            cursorView.widthAnchor.constraint(equalToConstant: 24.scale),
            cursorView.heightAnchor.constraint(equalToConstant: 24.scale),
            cursorView.centerYAnchor.constraint(equalTo: datePickerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: dontKnowButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            dontKnowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            dontKnowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            dontKnowButton.heightAnchor.constraint(equalToConstant: 25.scale),
            dontKnowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideWhenTakingView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.semiBold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideWhenTaking.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDatePickerView() -> UIDatePicker {
        let minimumDate = Calendar.current.date(byAdding: .day, value: 6, to: Date()) ?? Date()
        
        let startDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.backgroundColor = UIColor.clear
        view.minimumDate = minimumDate
        view.date = startDate
        view.locale = Locale.current
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        view.setValue(UIColor(integralRed: 255, green: 101, blue: 1), forKeyPath: "textColor")
        view.datePickerMode = .countDownTimer
        view.datePickerMode = .date
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCursorView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Cursor")
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
    
    func makeDontNowButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
            .font(Fonts.SFProRounded.regular(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.setAttributedTitle("Onboarding.SlideWhenTaking.DontKnow".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
