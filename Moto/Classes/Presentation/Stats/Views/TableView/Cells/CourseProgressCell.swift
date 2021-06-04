//
//  CourseProgressCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 24.01.2021.
//

import UIKit

class CourseProgressCell: UITableViewCell {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var containerView = makeContainerView()
    private lazy var stackView = makeStackView()
    private lazy var testTakenProgress = makeProgressView()
    private lazy var correctAnswersProgress = makeProgressView()
    private lazy var questionsTakenProgress = makeProgressView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CourseProgressCell {
    func setup(model: CourseStatsElement) {
        let attr = TextAttributes()
            .textColor(.black)
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.left)
        
        titleLabel.attributedText = model.name.attributed(with: attr)
        testTakenProgress.setup(percent: model.testsTaken, color: StatsPalette.Progress.testTaken)
        correctAnswersProgress.setup(percent: model.correctAnswers, color: StatsPalette.Progress.correctAnswers)
        questionsTakenProgress.setup(percent: model.questionsTaken, color: StatsPalette.Progress.questionsTaken)
    }
}

// MARK: Private
private extension CourseProgressCell {
    func configure() {
        [testTakenProgress, correctAnswersProgress, questionsTakenProgress].forEach(stackView.addArrangedSubview)
    }
}

// MARK: Make constraints
private extension CourseProgressCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15.scale),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.scale),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 15.scale),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.scale),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20.scale),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CourseProgressCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> CourseProgressView {
        let view = CourseProgressView()
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = .white
        contentView.addSubview(view)
        return view
    }
}
