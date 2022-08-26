//
//  LocaleTableViewCell.swift
//  CDL
//
//  Created by Andrey Chernyshev on 25.05.2021.
//

import UIKit

final class LocaleTableViewCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LocaleTableViewCell {
    func setup(element: LocaleTableViewElement) {
        container.backgroundColor = element.isSelected ? Onboarding.pickerText : UIColor(integralRed: 253, green: 246, blue: 241)
        
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(element.isSelected ? UIColor.white : Onboarding.pickerText)
            .lineHeight(28.scale)
        label.attributedText = element.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension LocaleTableViewCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension LocaleTableViewCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.5.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12.5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LocaleTableViewCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 26.5.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
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
