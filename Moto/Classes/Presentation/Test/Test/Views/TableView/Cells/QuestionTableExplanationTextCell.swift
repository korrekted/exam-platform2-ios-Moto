//
//  ExplanationCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import UIKit

final class QuestionTableExplanationTextCell: UITableViewCell {
    lazy var explanationLabel = makeExplanationLabel()

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
extension QuestionTableExplanationTextCell {
    func confugure(explanation: String, html: String) {
        let attr = TextAttributes()
            .font(Fonts.Lato.regular(size: 17.scale))
            .textColor(TestPalette.explanationText)
            .lineHeight(23.8.scale)
        
        explanationLabel.attributedText = attributedString(for: html) ?? explanation.attributed(with: attr)
    }
}

// MARK: Private
private extension QuestionTableExplanationTextCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func attributedString(for htmlString: String) -> NSAttributedString? {
        guard !htmlString.isEmpty else { return nil }
        
        let font = Fonts.Lato.regular(size: 17.scale)
        let htmlWithStyle = "<span style=\"font-family: \(font.fontName); font-style: regular; font-size: \(font.pointSize)px; line-height: \(23.8.scale)px;\">\(htmlString)</span>"
        let data = Data(htmlWithStyle.utf8)
        
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        
        return attributedString
    }
}

// MARK: Make constraints
private extension QuestionTableExplanationTextCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            explanationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            explanationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            explanationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionTableExplanationTextCell {
    func makeExplanationLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
