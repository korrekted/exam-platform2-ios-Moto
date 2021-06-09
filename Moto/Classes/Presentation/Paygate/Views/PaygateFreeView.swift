//
//  PaygateFreeView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 08.06.2021.
//

import UIKit

final class PaygateFreeView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var infoCell1 = makeInfoCell(title: "Paygate.Free.Cell1")
    lazy var infoCell2 = makeInfoCell(title: "Paygate.Free.Cell2")
    lazy var infoCell3 = makeInfoCell(title: "Paygate.Free.Cell3")
    lazy var continueButton = makeContinueButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PaygateFreeView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 237, green: 237, blue: 237)
        
        layer.cornerRadius = 20.scale
    }
}

// MARK: Make constraints
private extension PaygateFreeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoCell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoCell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoCell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoCell2.topAnchor.constraint(equalTo: infoCell1.bottomAnchor, constant: 11.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoCell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoCell3.topAnchor.constraint(equalTo: infoCell2.bottomAnchor, constant: 11.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 50.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateFreeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 255, green: 101, blue: 1))
            .font(Fonts.SFProRounded.bold(size: 24.scale))
            .lineHeight(29.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Free.Title".localized.attributed(with: attrs)
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
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.regular(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.Free.Continue".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor(integralRed: 31, green: 31, blue: 31)
        view.layer.cornerRadius = 26.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
