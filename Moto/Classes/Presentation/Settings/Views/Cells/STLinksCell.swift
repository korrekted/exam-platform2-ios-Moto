//
//  STLinksCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 26.01.2021.
//

import UIKit

final class STLinksCell: UITableViewCell {
    var tapped: ((SettingsTableView.Tapped) -> Void)?
    
    lazy var rateUsView = makeRateUsView()
    lazy var contactUsView = makeContactUsView()
    lazy var termsOfUse = makeTermsOfUseView()
    lazy var privacyPolicyView = makePrivacyPolicyView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension STLinksCell {
    func initialize() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        
        switch tag {
        case 1:
            tapped?(.rateUs)
        case 2:
            tapped?(.contactUs)
        case 3:
            tapped?(.termsOfUse)
        case 4:
            tapped?(.privacyPoliicy)
        default:
            break
        }
    }
}

// MARK: Make constraints
private extension STLinksCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            rateUsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            rateUsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            rateUsView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contactUsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            contactUsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            contactUsView.topAnchor.constraint(equalTo: rateUsView.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUse.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            termsOfUse.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            termsOfUse.topAnchor.constraint(equalTo: contactUsView.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            privacyPolicyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            privacyPolicyView.topAnchor.constraint(equalTo: termsOfUse.bottomAnchor, constant: 10.scale),
            privacyPolicyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension STLinksCell {
    func makeRateUsView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 1
        view.label.attributedText = "Settings.RateUs".localized.attributed(with: .attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContactUsView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 2
        view.label.attributedText = "Settings.ContactUs".localized.attributed(with: .attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTermsOfUseView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 3
        view.label.attributedText = "Settings.TermsOfUse".localized.attributed(with: .attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePrivacyPolicyView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 4
        view.label.attributedText = "Settings.PrivacyPolicy".localized.attributed(with: .attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let attr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 18.scale))
        .lineHeight(25.scale)
        .textColor(SettingsPalette.itemTitle)
}
