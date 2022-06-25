//
//  TestStatsAnswerCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

class TestStatsAnswerCell: UITableViewCell {
    
    private lazy var containerView = makeContainerView()
    private lazy var answerLabel = makeAnswerLabel()

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
extension TestStatsAnswerCell {
    func setup(element: TestStatsAnswerElement) {
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 18.scale))
            .lineHeight(24)
            .textColor(TestStatsPalette.answerText)
        
        answerLabel.attributedText = element.question.attributed(with: attr)
        
        let color = element.isCorrect
            ? TestStatsPalette.correct
            : TestStatsPalette.incorrect
        
        containerView.backgroundColor = color
    }
}

// MARK: Private
private extension TestStatsAnswerCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TestStatsAnswerCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.scale),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            answerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12.scale),
            answerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.scale),
            answerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16.scale),
            answerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsAnswerCell {
    func makeContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20.scale
        contentView.addSubview(view)
        return view
    }
    
    func makeAnswerLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}
