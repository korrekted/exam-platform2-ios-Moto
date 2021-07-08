//
//  OExperienceCursor.swift
//  Moto
//
//  Created by Andrey Chernyshev on 08.07.2021.
//

import UIKit

final class ODrivingExperienceCursor: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    lazy var title: String = "" {
        didSet {
            let attrs = TextAttributes()
                .textColor(UIColor.white)
                .font(Fonts.SFProRounded.regular(size: 16.scale))
                .lineHeight(22.4.scale)
                .textAlignment(.center)
            label.attributedText = title.attributed(with: attrs)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension ODrivingExperienceCursor {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ODrivingExperienceCursor {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Onboarding.DrivingExperience")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
