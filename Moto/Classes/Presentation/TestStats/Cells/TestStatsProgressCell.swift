//
//  TestStatsProgressCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

class TestStatsProgressCell: UITableViewCell {

    lazy var progressView = makeProgressView()
    lazy var percentLabel = makePercentLabel()
    lazy var passingContainer = makePassingContainer()
    lazy var passingIcon = makeImageView()
    lazy var passingScoreLabel = makePassScoreLabel()

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
extension TestStatsProgressCell {
    func setup(element: TestStatsProgressElement) {
        let progress = min(CGFloat(element.percent) / 100, 1)
        progressView.progress(progress: progress, passingScore: min(CGFloat(element.passingScore) / 100, 1))
        percentLabel.text = "\(element.percent) %"
        
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 16.scale))
            .textColor(TestStatsPalette.Progress.text)
        
        passingScoreLabel.attributedText = "\("TestStats.PassingScore".localized) \(element.passingScore)%".attributed(with: attr)
    }
}

// MARK: Private
private extension TestStatsProgressCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TestStatsProgressCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 150.scale),
            progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passingContainer.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16.scale),
            passingContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale),
            passingContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passingIcon.leadingAnchor.constraint(equalTo: passingContainer.leadingAnchor),
            passingIcon.heightAnchor.constraint(equalToConstant: 8.scale),
            passingIcon.widthAnchor.constraint(equalTo: passingIcon.heightAnchor),
            passingIcon.centerYAnchor.constraint(equalTo: passingScoreLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passingScoreLabel.topAnchor.constraint(equalTo: passingContainer.topAnchor),
            passingScoreLabel.bottomAnchor.constraint(equalTo: passingContainer.bottomAnchor),
            passingScoreLabel.leadingAnchor.constraint(equalTo: passingIcon.trailingAnchor, constant: 8.scale),
            passingScoreLabel.trailingAnchor.constraint(equalTo: passingContainer.trailingAnchor)
        ])
        
    }
}

// MARK: Lazy initialization
private extension TestStatsProgressCell {
    func makeProgressView() -> TestStatsProgressView {
        let view = TestStatsProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Fonts.SFProRounded.bold(size: 36.scale)
        view.textColor = TestStatsPalette.Progress.text
        view.translatesAutoresizingMaskIntoConstraints = false
        passingContainer.addSubview(view)
        return view
    }
    
    func makePassScoreLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Question.Circle")
        view.tintColor = TestStatsPalette.passingScore
        view.translatesAutoresizingMaskIntoConstraints = false
        passingContainer.addSubview(view)
        return view
    }
    
    func makePassingContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
