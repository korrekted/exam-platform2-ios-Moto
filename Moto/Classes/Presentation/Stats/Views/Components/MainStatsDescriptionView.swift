//
//  MainStatsDescriptionView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 25.01.2021.
//

import UIKit

class MainStatsDescriptionView: UIView {
    private lazy var stackView = makeStackView()
    private lazy var testTakenLineView = makeLineView()
    private lazy var longestStreakLineView = makeLineView()
    private lazy var answeredQuestionsLineView = makeLineView()
    private lazy var correctAnswersLineView = makeLineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainStatsDescriptionView {
    func setup(model: MainStatsElement) {
        let longestStreakValue = String.choosePluralForm(
            byNumber: model.longestStreak,
            one: "Stats.Day.One".localized,
            two: "Stats.Day.Two".localized,
            many: "Stats.Day.Many".localized
        )
        
        testTakenLineView.setup(title: "Stats.MainRate.TestsTake".localized, value: "\(model.testsTakenNum)")
        longestStreakLineView.setup(title: "Stats.MainRate.LongestStreak".localized, value: "\(model.longestStreak) \(longestStreakValue)")
        answeredQuestionsLineView.setup(title: "Stats.MainRate.AnsweredQuestions".localized, value: "\(model.answeredQuestions)")
        correctAnswersLineView.setup(title: "Stats.MainRate.CorrectAnswers".localized, value: "\(model.correctAnswersNum)")
    }
}

// MARK: Make constraints
private extension MainStatsDescriptionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure() {
        layer.cornerRadius = 20.scale
        [testTakenLineView, makeSeparatorView(), correctAnswersLineView, makeSeparatorView(), answeredQuestionsLineView, makeSeparatorView(), longestStreakLineView].forEach(stackView.addArrangedSubview)
    }
}

// MARK: Lazy initialization
private extension MainStatsDescriptionView {
    func makeLineView() -> MainStatsDescriptionLineView {
        let view = MainStatsDescriptionLineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = StatsPalette.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.scale).isActive = true
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
