//
//  TestStatsResultView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

class TestStatsResultView: UIView {
        
    private lazy var stackView = makeStackView()
    
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
extension TestStatsResultView {
    func setup(element: TestStatsDescriptionElement) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        if let attemped = element.attempted {
            let view = makeLineView()
            view.setup(title: "TestStats.Attempted".localized, value: "\(attemped)")
            stackView.addArrangedSubview(view)
            stackView.addArrangedSubview(makeSeparatorView())
        }
        
        let correct = makeLineView()
        correct.setup(title: "TestStats.Correct".localized, value: "\(element.correctNumber)")
        stackView.addArrangedSubview(correct)
        stackView.addArrangedSubview(makeSeparatorView())
        
        let incorrect = makeLineView()
        incorrect.setup(title: "TestStats.Incorrect".localized, value: "\(element.incorrectNumber)")
        stackView.addArrangedSubview(incorrect)
        
        setNeedsLayout()
    }
}

// MARK: Private
private extension TestStatsResultView {
    func configure() {
        layer.cornerRadius = 12.scale
    }
}

// MARK: Make constraints
private extension TestStatsResultView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsResultView {
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
