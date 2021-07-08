//
//  OModeCell.swift
//  CDL
//
//  Created by Andrey Chernyshev on 21.06.2021.
//

import UIKit

final class OModeCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var subtitleLabel = makeLabel()
    
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
extension OModeCell {
    func setup(element: OModeCollectionElement) {
        imageView.image = UIImage(named: element.image)
        
        titleLabel.attributedText = element.title
            .attributed(with: TextAttributes()
                .font(Fonts.SFProRounded.semiBold(size: 20.scale))
                .lineHeight(28.scale)
                .textColor(UIColor(integralRed: 19, green: 24, blue: 42))
                .textAlignment(.center))
        
        subtitleLabel.attributedText = element.subtitle
            .attributed(with: TextAttributes()
                .font(Fonts.SFProRounded.regular(size: 16.scale))
                            .lineHeight(22.4.scale)
                .textColor(UIColor(integralRed: 75, green: 81, blue: 102))
                .textAlignment(.center))
        
        container.layer.borderWidth = element.isSelected ? 2.scale : 0
        container.layer.borderColor = element.isSelected ? UIColor(integralRed: 255, green: 101, blue: 1).cgColor : UIColor.clear.cgColor
    }
}

// MARK: Private
private extension OModeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension OModeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 56.scale),
            imageView.heightAnchor.constraint(equalToConstant: 48.scale),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24.scale),
            subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24.scale),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OModeCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 253, green: 246, blue: 241)
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
