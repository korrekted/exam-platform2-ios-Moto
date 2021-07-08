//
//  OExperienceCell.swift
//  DMV
//
//  Created by Andrey Chernyshev on 05.07.2021.
//

import UIKit

final class OExperienceCell: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var subtitleLabel = makeLabel()
    
    var isChecked: Bool = false {
        didSet {
            layer.borderWidth = isChecked ? 2.scale : 0
            layer.borderColor = isChecked ? UIColor(integralRed: 255, green: 101, blue: 1).cgColor : UIColor.clear.cgColor
        }
    }
    
    var title: String = "" {
        didSet {
            let attrs = TextAttributes()
                .font(Fonts.SFProRounded.semiBold(size: 20.scale))
                .lineHeight(28.scale)
                .textColor(UIColor(integralRed: 255, green: 101, blue: 1))
            
            titleLabel.attributedText = title.attributed(with: attrs)
        }
    }
    
    var subtitle: String = "" {
        didSet {
            let attrs = TextAttributes()
                .font(Fonts.SFProRounded.regular(size: 20.scale))
                .lineHeight(28.scale)
                .textColor(UIColor(integralRed: 68, green: 68, blue: 68))
            
            subtitleLabel.attributedText = subtitle.attributed(with: attrs)
        }
    }
    
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
private extension OExperienceCell {
    func initialize() {
        backgroundColor = UIColor(integralRed: 253, green: 246, blue: 241)
        
        layer.cornerRadius = 20.scale
    }
}

// MARK: Make constraints
private extension OExperienceCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 55.scale),
            imageView.heightAnchor.constraint(equalToConstant: 66.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 92.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 92.scale),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OExperienceCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
