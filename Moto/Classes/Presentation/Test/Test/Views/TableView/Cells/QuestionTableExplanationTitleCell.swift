//
//  QuestionTableExplanationTitleCell.swift
//  CDL
//
//  Created by Андрей Чернышев on 21.06.2022.
//

import UIKit

final class QuestionTableExplanationTitleCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension QuestionTableExplanationTitleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension QuestionTableExplanationTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.scale),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionTableExplanationTitleCell {
    func makeTitleLabel() -> UILabel {
        let attr = TextAttributes()
            .font(Fonts.Lato.bold(size: 18.scale))
            .textColor(TestPalette.explanationTitle)
            .lineHeight(25.2.scale)
        
        let view = UILabel()
        view.attributedText = "Question.Explanation".localized.attributed(with: attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
