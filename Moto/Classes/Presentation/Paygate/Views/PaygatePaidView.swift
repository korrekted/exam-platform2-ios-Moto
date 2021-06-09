//
//  PaygatePaidView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 08.06.2021.
//

import UIKit

final class PaygatePaidView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var infoCell1 = makeInfoCell(title: "Paygate.Paid.Cell1")
    lazy var infoCell2 = makeInfoCell(title: "Paygate.Paid.Cell2")
    lazy var infoCell3 = makeInfoCell(title: "Paygate.Paid.Cell3")
    lazy var option1View = makeOptionView()
    lazy var option2View = makeOptionView()
    lazy var continueButton = makeContinueButton()
    lazy var preloader = makePreloader()
    
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
extension PaygatePaidView {
    func setup(options: [PaygateOption]) {
        if let option1 = options.first {
            option1View.isSelected = true
            option1View.setup(option: option1)
        } else {
            option1View.isHidden = true
        }
        
        if options.count > 1, let option2 = options.last {
            option2View.isSelected = false
            option2View.setup(option: option2)
        } else {
            option2View.isHidden = true
        }
    }
    
    func inProgress(_ isActive: Bool) {
        isActive ? preloader.startAnimating() : preloader.stopAnimating()
        
        option1View.isHidden = isActive
        option2View.isHidden = isActive
    }
}

// MARK: Private
private extension PaygatePaidView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 237, green: 237, blue: 237)
        
        layer.cornerRadius = 20.scale
    }
}

// MARK: Make constraints
private extension PaygatePaidView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 24.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoCell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoCell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 12.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoCell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoCell2.topAnchor.constraint(equalTo: infoCell1.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 11.scale : 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoCell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoCell3.topAnchor.constraint(equalTo: infoCell2.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 11.scale : 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            option1View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            option1View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            option1View.heightAnchor.constraint(equalToConstant: 104.scale),
            option1View.topAnchor.constraint(equalTo: infoCell3.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 15.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            option2View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            option2View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            option2View.heightAnchor.constraint(equalToConstant: 104.scale),
            option2View.topAnchor.constraint(equalTo: option1View.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 50.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -24.scale : -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -140.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygatePaidView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 255, green: 101, blue: 1))
            .font(Fonts.SFProRounded.bold(size: 24.scale))
            .lineHeight(29.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Paid.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInfoCell(title: String) -> PaygateInfoCell {
        let view = PaygateInfoCell()
        view.backgroundColor = UIColor.clear
        view.title = title.localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOptionView() -> PaygateOptionView {
        let view = PaygateOptionView()
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.regular(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.Paid.Continue".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor(integralRed: 31, green: 31, blue: 31)
        view.layer.cornerRadius = 26.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
