//
//  MainRateCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 24.01.2021.
//

import UIKit

class MainRateCell: UITableViewCell {
    private lazy var stackStatsView = makeStackView()
    private lazy var testTakenStatsView = makeMainStatsView()
    private lazy var correctAnswersStatsView = makeMainStatsView()
    private lazy var questionsTakenStatsView = makeMainStatsView()
    private lazy var statsDescriptionView = makeStatsDescriptionView()
    private lazy var mainProgressView = makeMainProgressView()

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
extension MainRateCell {
    func setup(model: MainStatsElement) {
        testTakenStatsView.setPercent(percent: model.testTaken)
        correctAnswersStatsView.setPercent(percent: model.correctAnswers)
        questionsTakenStatsView.setPercent(percent: model.questionsTaken)
        statsDescriptionView.setup(model: model)
        mainProgressView.setProgress(big: model.testTaken, medium: model.correctAnswers, small: model.questionsTaken)
    }
}

// MARK: Private
private extension MainRateCell {
    func configure() {
        contentView.backgroundColor = .clear
        
        [testTakenStatsView, correctAnswersStatsView, questionsTakenStatsView].forEach(stackStatsView.addArrangedSubview)
        
        testTakenStatsView.setup(title: "Stats.MainRate.TestsTake".localized,
                                 color: StatsPalette.Progress.testTaken)
        
        correctAnswersStatsView.setup(title: "Stats.MainRate.CorrectAnswers".localized,
                                      color: StatsPalette.Progress.correctAnswers)
        
        questionsTakenStatsView.setup(title: "Stats.MainRate.QuestionsTaken".localized,
                                      color: StatsPalette.Progress.questionsTaken)
    }
}

// MARK: Make constraints
private extension MainRateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackStatsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackStatsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackStatsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            stackStatsView.bottomAnchor.constraint(equalTo: mainProgressView.topAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            mainProgressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 65.scale),
            mainProgressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -65.scale),
            mainProgressView.heightAnchor.constraint(equalTo: mainProgressView.widthAnchor, multiplier: 0.51),
            mainProgressView.bottomAnchor.constraint(equalTo: statsDescriptionView.topAnchor, constant: 25.scale),
        ])
        
        NSLayoutConstraint.activate([
            statsDescriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statsDescriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statsDescriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainRateCell {
    func makeMainStatsView() -> MainStatsView {
        let view = MainStatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeStatsDescriptionView() -> MainStatsDescriptionView {
        let view = MainStatsDescriptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = StatsPalette.Description.background
        contentView.addSubview(view)
        return view
    }
    
    func makeMainProgressView() -> MainProgressView {
        let view = MainProgressView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
