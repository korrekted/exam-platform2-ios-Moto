//
//  TryAgainView.swift
//  Moto
//
//  Created by Андрей Чернышев on 20.05.2022.
//

import UIKit

final class TryAgainView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var tryAgainButton = makeButton()
    lazy var contactButton = makeContactButton()
    
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
private extension TryAgainView {
    func initialize() {
        backgroundColor = TryAgainPalette.background
    }
}

// MARK: Make constraints
private extension TryAgainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 281.scale),
            imageView.heightAnchor.constraint(equalToConstant: 207.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 117.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tryAgainButton.widthAnchor.constraint(equalToConstant: 323.scale),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 60.scale),
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.bottomAnchor.constraint(equalTo: contactButton.topAnchor, constant: -15.scale)
        ])
        
        NSLayoutConstraint.activate([
            contactButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            contactButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            contactButton.heightAnchor.constraint(equalToConstant: 24.scale),
            contactButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TryAgainView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "TryAgain.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(TryAgainPalette.title)
            .font(Fonts.SFProRounded.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TryAgain.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(TryAgainPalette.subTitle)
            .font(Fonts.SFProRounded.regular(size: 19.scale))
            .lineHeight(26.6.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TryAgain.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
        
        let view = UIButton()
        view.setAttributedTitle("TryAgain.Button".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = TryAgainPalette.tryAgainButtonBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContactButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(TryAgainPalette.title)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("TryAgain.Contact".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
