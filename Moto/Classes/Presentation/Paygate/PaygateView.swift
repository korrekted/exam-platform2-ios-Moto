//
//  PaygateView.swift
//  SleepWell
//
//  Created by Andrey Chernyshev on 12/06/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class PaygateView: UIView {
    lazy var restoreButton = makeRestoreButton()
    lazy var scrollView = makeScrollView()
    lazy var indicatorsView = makeIndicatosView()
    lazy var lockImageView = makeLockIconView()
    lazy var securedLabel = makeSecuredLabel()
    lazy var termsAndPolicyLabel = makeTermsAndPolicyLabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        scrollViewDidScroll(scrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UIScrollViewDelegate
extension PaygateView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionPage = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractionPage))
        
        indicatorsView.select(isFirst: page == 1)
    }
}

// MARK: Private
private extension PaygateView {
    func initialize() {
        backgroundColor = PaygatePalette.background
    }
    
    @objc
    private func termsAndPolicyTapped(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, let text = label.text as NSString? else {
            return
        }
        
        let termsRange = text.range(of: "Paygate.TermsOfUse".localized)
        let policyRange = text.range(of: "Paygate.PrivacyPolicy".localized)
        
        var url: URL?

        if sender.didTapAttributedTextInLabel(label: label, inRange: termsRange) {
            url = URL(string: GlobalDefinitions.termsOfServiceUrl)
        } else if sender.didTapAttributedTextInLabel(label: label, inRange: policyRange) {
            url = URL(string: GlobalDefinitions.privacyPolicyUrl)
        }
        
        guard let openUrl = url else {
            return
        }
        
        UIApplication.shared.open(openUrl, options: [:])
    }
}

// MARK: Make constraints
private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            restoreButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 64.scale : 25.scale),
            restoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14.scale),
            restoreButton.heightAnchor.constraint(equalToConstant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 60.scale),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -143.scale : -100.scale)
        ])
        
        NSLayoutConstraint.activate([
            indicatorsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorsView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockImageView.widthAnchor.constraint(equalToConstant: 17.scale),
            lockImageView.heightAnchor.constraint(equalToConstant: 17.scale),
            lockImageView.trailingAnchor.constraint(equalTo: securedLabel.leadingAnchor, constant: -8.scale),
            lockImageView.bottomAnchor.constraint(equalTo: termsAndPolicyLabel.topAnchor, constant: ScreenSize.isIphoneXFamily ? -35.scale : -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            securedLabel.centerYAnchor.constraint(equalTo: lockImageView.centerYAnchor),
            securedLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsAndPolicyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            termsAndPolicyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            termsAndPolicyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -32.scale : -15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateView {
    func makeRestoreButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 68, green: 68, blue: 68))
            .font(Fonts.SFProRounded.regular(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.RestorePurchases".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> PaygateScrollView {
        let view = PaygateScrollView()
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIndicatosView() -> PaygateIndicatorView {
        let view = PaygateIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLockIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSecuredLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 68, green: 68, blue: 68))
            .font(Fonts.SFProRounded.regular(size: 14.scale))
            .lineHeight(17.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Info".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsAndPolicyLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 14.scale))
            .lineHeight(19.5.scale)
            .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
            .textAlignment(.center)
            .dictionary
        
        var underlineAtts = attrs
        underlineAtts[.underlineStyle] = NSUnderlineStyle.single.rawValue
        
        let terms = NSAttributedString(string: "Paygate.TermsOfUse".localized, attributes: underlineAtts)
        let and = NSAttributedString(string: "Paygate.And".localized, attributes: attrs)
        let policy = NSAttributedString(string: "Paygate.PrivacyPolicy".localized, attributes: underlineAtts)
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(terms)
        attributedText.append(and)
        attributedText.append(policy)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsAndPolicyTapped(sender:)))
        
        let view = UILabel()
        view.attributedText = attributedText
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
