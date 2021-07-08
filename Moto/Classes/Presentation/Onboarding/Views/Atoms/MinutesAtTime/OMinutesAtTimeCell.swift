//
//  OMinutesAtTimeCell.swift
//  CDL
//
//  Created by Andrey Chernyshev on 28.06.2021.
//

import UIKit

final class OMinutesAtTimeCell: UIView {
    var isSelected: Bool = false {
        didSet {
            layer.borderWidth = isSelected ? 2.scale : 0
            layer.borderColor = isSelected ? UIColor(integralRed: 255, green: 101, blue: 1).cgColor : UIColor.clear.cgColor
        }
    }
    
    var element: MinutesAtTimeElement? = nil {
        didSet {
            fill()
        }
    }
    
    lazy var titleLabel = makeLabel()
    lazy var minutesLabel = makeLabel()
    
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
private extension OMinutesAtTimeCell {
    func initialize() {
        backgroundColor = UIColor(integralRed: 253, green: 246, blue: 241)
    }
    
    func fill() {
        guard let element = self.element else {
            return
        }
        
        titleLabel.attributedText = element
            .title
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 255, green: 101, blue: 1))
                            .font(Fonts.SFProRounded.regular(size: 20.scale))
                            .lineHeight(28.scale))
        
        minutesLabel.attributedText = element
            .subTitle
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 75, green: 81, blue: 102))
                            .font(Fonts.SFProRounded.regular(size: 20.scale))
                            .lineHeight(28.scale))
    }
}

// MARK: Make constraints
private extension OMinutesAtTimeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minutesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            minutesLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OMinutesAtTimeCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
