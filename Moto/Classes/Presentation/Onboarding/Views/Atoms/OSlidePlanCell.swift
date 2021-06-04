//
//  OSlide15Cell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

final class OSlidePlanCell: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
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
private extension OSlidePlanCell {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension OSlidePlanCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 25.scale),
            imageView.heightAnchor.constraint(equalToConstant: 25.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 39.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 76.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlidePlanCell {
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
        view.textColor = Onboarding.primaryText
        view.font = Fonts.SFProRounded.regular(size: 20.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
