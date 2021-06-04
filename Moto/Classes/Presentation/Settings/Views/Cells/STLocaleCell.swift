//
//  STLocaleCell.swift
//  CDL
//
//  Created by Andrey Chernyshev on 26.05.2021.
//

import UIKit

final class STLocaleCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var valueLabel = makeLabel()
    
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
extension STLocaleCell {
    func setup(title: String, value: String) {
        let titleAttrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 18.scale))
            .lineHeight(25.2.scale)
            .textColor(UIColor(integralRed: 68, green: 68, blue: 68))
        titleLabel.attributedText = title.attributed(with: titleAttrs)
        
        let valueAttrs = TextAttributes()
            .font(Fonts.SFProRounded.bold(size: 18.scale))
            .lineHeight(25.2.scale)
            .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension STLocaleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension STLocaleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.scale),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension STLocaleCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
