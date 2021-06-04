//
//  OSlide7View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideTimeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cursorView = makeCursorView()
    lazy var pickerView = makePickerView()
    lazy var minLabel = makeMinLabel()
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UIPickerViewDataSource
extension OSlideTimeView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        12
    }
}

// MARK: UIPickerViewDelegate
extension OSlideTimeView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        
        if label == nil {
            label = UILabel()
            label?.backgroundColor = UIColor.clear
        }
        
        let attrs = TextAttributes()
            .textColor(Onboarding.pickerText)
            .font(Fonts.SFProRounded.bold(size: 32.scale))
            .lineHeight(38.scale)
        
        label?.attributedText = String((row + 1) * 5).attributed(with: attrs)
        
        label?.sizeToFit()
        
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        50.scale
    }
}

// MARK: Private
private extension OSlideTimeView {
    func initialize() {
        pickerView.reloadAllComponents()
        pickerView.selectRow(3, inComponent: 0, animated: false)
    }
}

// MARK: Make constraints
private extension OSlideTimeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -14.scale)
        ])
        
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale),
            pickerView.widthAnchor.constraint(equalToConstant: 375.scale),
            pickerView.heightAnchor.constraint(equalToConstant: 254.scale)
        ])
        
        NSLayoutConstraint.activate([
            cursorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 120.scale),
            cursorView.widthAnchor.constraint(equalToConstant: 24.scale),
            cursorView.heightAnchor.constraint(equalToConstant: 24.scale),
            cursorView.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -104.scale),
            minLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
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
private extension OSlideTimeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.bold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideTime.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCursorView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Cursor")
        view.tintColor = Onboarding.pickerText
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePickerView() -> UIPickerView {
        let view = PaddingPickerView()
        view.padding = UIEdgeInsets(top: 0, left: 200.scale, bottom: 0, right: 200.scale)
        view.backgroundColor = UIColor.clear
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMinLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.pickerText)
            .font(Fonts.SFProRounded.regular(size: 20.scale))
        
        let view = UILabel()
        view.attributedText = "Onboarding.SlideTime.Min".localized.attributed(with: attrs)
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
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
