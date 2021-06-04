//
//  SIQuestionCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 10.04.2021.
//

import UIKit

class SIQuestionCell: UITableViewCell {
    
    private lazy var questionLabel = makeQuestionLabel()

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
extension SIQuestionCell {
    func configure(question: String, questionHtml: String) {
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(TestPalette.questionText)
            .lineHeight(28.scale)
        
        questionLabel.attributedText = attributedString(for: questionHtml) ?? question.attributed(with: attr)
    }
    
    func attributedString(for htmlString: String) -> NSAttributedString? {
        guard !htmlString.isEmpty else { return nil }
        
        let font = Fonts.SFProRounded.semiBold(size: 20.scale)
        let htmlWithStyle = "<span style=\"font-family: \(font.fontName); font-style: 600; font-size: \(font.pointSize); line-height: 30px;\">\(htmlString)</span>"
        let data = Data(htmlWithStyle.utf8)
        
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        
        return attributedString
    }
}

// MARK: Private
private extension SIQuestionCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SIQuestionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            questionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11.scale),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SIQuestionCell {
    func makeQuestionLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
