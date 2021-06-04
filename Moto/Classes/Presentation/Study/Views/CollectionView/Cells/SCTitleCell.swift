//
//  SCTitleCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 31.01.2021.
//

import UIKit

final class SCTitleCell: UICollectionViewCell {
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

// MARK: API
extension SCTitleCell {
    func setup(title: String) {
        let attrs = TextAttributes()
            .textColor(StudyPalette.title)
            .font(Fonts.SFProRounded.regular(size: 20.scale))
        
        let nameAttr = TextAttributes()
            .textColor(StudyPalette.title)
            .font(Fonts.SFProRounded.bold(size: 20.scale))
        
        let attributes = NSMutableAttributedString()
        attributes.append(title.attributed(with: nameAttr))
        attributes.append("Study.Course.Title".localized.attributed(with: attrs))
        
        label.attributedText = attributes
    }
}

// MARK: Private
private extension SCTitleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension SCTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SCTitleCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        contentView.addSubview(view)
        return view
    }
}
