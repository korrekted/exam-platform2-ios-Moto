//
//  STLinkView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 26.01.2021.
//

import UIKit

final class STLinkView: UIView {
    lazy var label = makeLabel()
    lazy var arrowIcon = makeArrowIcon()
    
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
private extension STLinkView {
    func initialize() {
        backgroundColor = SettingsPalette.itemBackground
        layer.cornerRadius = 12.scale
    }
}

// MARK: Make constraints
private extension STLinkView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            arrowIcon.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowIcon.heightAnchor.constraint(equalToConstant: 22.scale),
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension STLinkView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowIcon() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Settings.Right")
        view.contentMode = .scaleAspectFit
        view.tintColor = SettingsPalette.buttonTint
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
