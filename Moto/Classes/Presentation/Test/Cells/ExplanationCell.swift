//
//  ExplanationCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import UIKit

class ExplanationCell: UITableViewCell {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var explanationLabel = makeExplanationLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Public
extension ExplanationCell {
    func confugure(explanation: String) {
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 18.scale))
            .textColor(TestPalette.explanationText)
            .lineHeight(25.scale)
        
        explanationLabel.attributedText = explanation.attributed(with: attr)
    }
}

// MARK: Private
private extension ExplanationCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ExplanationCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            titleLabel.bottomAnchor.constraint(equalTo: explanationLabel.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            explanationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28.scale),
            explanationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            explanationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExplanationCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(TestPalette.explanationTitle)
            .lineHeight(28.scale)
        
        view.attributedText = "Question.Explanation".localized.attributed(with: attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeExplanationLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        contentView.addSubview(view)
        return view
    }
}
