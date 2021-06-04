//
//  STUnlockCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

final class STUnlockCell: UITableViewCell {
    var tapped: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    private lazy var lockIcon = makeIconView()
    
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
private extension STUnlockCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didTap() {
        tapped?()
    }
}

// MARK: Make constraints
private extension STUnlockCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -25.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -25.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockIcon.heightAnchor.constraint(equalToConstant: 24.scale),
            lockIcon.widthAnchor.constraint(equalTo: lockIcon.heightAnchor),
            lockIcon.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            lockIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension STUnlockCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = SettingsPalette.unlockBackground
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(SettingsPalette.unlockTint)
            .font(Fonts.SFProRounded.regular(size: 14.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "Settings.Unlock".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(SettingsPalette.unlockTint)
            .font(Fonts.SFProRounded.bold(size: 24.scale))
            .lineHeight(29.scale)
        
        let view = UILabel()
        view.attributedText = "Settings.Premium".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Settings.Lock")
        view.tintColor = SettingsPalette.unlockTint
        view.contentMode = .scaleAspectFit
        container.addSubview(view)
        return view
    }
}
