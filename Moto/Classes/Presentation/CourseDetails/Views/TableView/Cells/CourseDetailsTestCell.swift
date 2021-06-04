//
//  CourseDetailsTestCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 24.04.2021.
//

import UIKit

class CourseDetailsTestCell: UITableViewCell {
    
    private lazy var container = makeContainer()
    private lazy var nameLabel = makeNameLabel()
    private lazy var questionsCountLabel = makeQuestionsLabel()
    private lazy var progressView = makeProgressView()
    let gradientLayer = CAGradientLayer()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = progressView.frame
    }
}

extension CourseDetailsTestCell {
    func setup(config: CourseDetailsTestConfig) {
        nameLabel.attributedText = config.name.attributed(with: .nameAttrs)
        questionsCountLabel.attributedText = "\(config.questionCounts) \("CourseDetails.Questions".localized)".attributed(with: .questionCountAttrs)
        progressView.setGradientLocation(correctPercent: config.correctProgress, incorrectPercent: config.incorrectProgress)
    }
}

private extension CourseDetailsTestCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

private extension CourseDetailsTestCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            questionsCountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4.scale),
            questionsCountLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            questionsCountLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: questionsCountLabel.bottomAnchor, constant: 9.scale),
            progressView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 8.scale),
            progressView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -22.scale)
        ])
    }
}

private extension CourseDetailsTestCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = CourseDetailsPalette.itemBackground
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeQuestionsLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeProgressView() -> GradientProgressView {
        let view = GradientProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4.scale
        view.backgroundColor = CourseDetailsPalette.emptyGradient
        container.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let nameAttrs = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 20.scale))
        .textColor(CourseDetailsPalette.title)
    
    static let questionCountAttrs = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 16.scale))
        .textColor(CourseDetailsPalette.subtitle)
}
