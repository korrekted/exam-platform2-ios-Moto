//
//  QuestionTableQuestionReferenceCell.swift
//  CDL
//
//  Created by Андрей Чернышев on 21.06.2022.
//

import UIKit

final class QuestionTableQuestionReferenceCell: UITableViewCell {
    lazy var referenceLabel = makeReferenceLabel()

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
extension QuestionTableQuestionReferenceCell {
    func confugure(reference: String) {
        let attrs = TextAttributes()
            .font(Fonts.Lato.regular(size: 12.scale))
            .textColor(TestPalette.explanationTitle)
            .lineHeight(14.scale)
            .textAlignment(.center)
        
        referenceLabel.attributedText = reference.attributed(with: attrs)
    }
}

// MARK: Private
private extension QuestionTableQuestionReferenceCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension QuestionTableQuestionReferenceCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            referenceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            referenceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            referenceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            referenceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionTableQuestionReferenceCell {
    func makeReferenceLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
