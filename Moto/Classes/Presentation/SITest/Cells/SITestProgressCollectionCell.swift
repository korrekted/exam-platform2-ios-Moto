//
//  SITestProgressCollectionCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 08.04.2021.
//

import UIKit

class SITestProgressCollectionCell: UICollectionViewCell {
    
    private lazy var label = makeLabel()
    
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
extension SITestProgressCollectionCell {
    func setup(element: SIProgressElement) {
        var attr: TextAttributes = .attr
        
        if element.isSelected {
            attr = attr.textColor(TestPalette.QuestionNumber.selectedText)
            backgroundColor = TestPalette.QuestionNumber.selectedBackground
        } else {
            attr = attr.textColor(TestPalette.QuestionNumber.text)
            backgroundColor = TestPalette.QuestionNumber.background
        }
        
        label.attributedText = "\(element.index)".attributed(with: attr)
    }
}

// MARK: Private
private extension SITestProgressCollectionCell {
    func initialize() {
        layer.cornerRadius = 18.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension SITestProgressCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SITestProgressCollectionCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        contentView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let attr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.center)
}
