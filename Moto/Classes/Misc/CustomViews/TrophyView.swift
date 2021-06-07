//
//  TrophyView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 31.03.2021.
//

import UIKit

class TrophyView: UIView {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var imageView = makeImageView()
    private lazy var containerView = makeContainerView()
    private lazy var button = makeButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TrophyView {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension TrophyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 15.scale),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12.scale),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -19.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9.scale),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15.scale),
            button.heightAnchor.constraint(equalToConstant: 36.scale),
            button.widthAnchor.constraint(equalToConstant: 123.scale)
        ])
        
        let heightImage = imageView.heightAnchor.constraint(equalToConstant: 137.scale)
        heightImage.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 15.scale),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32.scale),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100.scale),
            heightImage
        ])
    }
}


// MARK: Lazy initialization
private extension TrophyView {
    func makeButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = TrophyPalette.buttonBackground
        view.setAttributedTitle("Trophy.LearnMore".localized.attributed(with: .buttonAttr), for: .normal)
        view.layer.cornerRadius = 17.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor.white.cgColor
        view.isUserInteractionEnabled = false
        containerView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.attributedText = "Trophy.Title".localized.attributed(with: .titleAttr)
        view.numberOfLines = 2
        containerView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "General.Trophy")
        view.contentMode = .scaleAspectFit
        addSubview(view)
        return view
    }
    
    func makeContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = TrophyPalette.background
        addSubview(view)
        return view
    }
}


private extension TextAttributes {
    static let buttonAttr = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 14.scale))
        .lineHeight(16.scale)
        .textColor(TrophyPalette.buttonTint)
        .textAlignment(.center)
    
    static let titleAttr = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 16.scale))
        .textColor(TrophyPalette.title)
}
