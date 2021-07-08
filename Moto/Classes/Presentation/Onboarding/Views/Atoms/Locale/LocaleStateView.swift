//
//  OSlideStateView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit
import RxSwift

final class LocaleStateView: UIView {
    var onNext: (() -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var pickerView = makePickerView()
    lazy var cursorView = makeCursorView()
    lazy var button = makeButton()
    
    lazy var states = [State]()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LocaleStateView {
    func setup(states: [State]) {
        self.states = states.sorted(by: { $0.sort < $1.sort })
        
        pickerView.reloadAllComponents()
    }
}

// MARK: UIPickerViewDataSource
extension LocaleStateView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        states.count
    }
}

// MARK: UIPickerViewDelegate
extension LocaleStateView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        
        if label == nil {
            label = UILabel()
            label?.backgroundColor = UIColor.clear
        }
        
        let attrs = TextAttributes()
            .textColor(Onboarding.pickerText)
            .font(Fonts.SFProRounded.bold(size: 24.scale))
        
        label?.attributedText = states[row].name.attributed(with: attrs)
        
        label?.sizeToFit()
        
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40.scale
    }
}

// MARK: Private
private extension LocaleStateView {
    func initialize() {
        pickerView.reloadAllComponents()
        
        nextAction()
    }
    
    func nextAction() {
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.onNext?()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension LocaleStateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24.scale),
            pickerView.widthAnchor.constraint(equalToConstant: 375.scale),
            pickerView.heightAnchor.constraint(equalToConstant: 417.scale)
        ])
        
        NSLayoutConstraint.activate([
            cursorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            cursorView.widthAnchor.constraint(equalToConstant: 24.scale),
            cursorView.heightAnchor.constraint(equalToConstant: 24.scale),
            cursorView.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
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
private extension LocaleStateView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.bold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideState.Title".localized.attributed(with: attrs)
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
}
