//
//  AnswerCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//
import UIKit
import RxSwift

final class AnswerCell: UITableViewCell {
    
    private lazy var answerView = makeAnswerView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        answerView.state =  isSelected ? .selected : state ?? .initial
    }
    
    private var state: AnswerView.State?
}

// MARK: Public
extension AnswerCell {
    func setup(element: AnswerElement) {
        answerView.setAnswer(answer: element.answer, image: element.image)
        
        switch element.state {
        case .initial:
            answerView.state = .initial
        case .correct:
            answerView.state = .correct
        case .warning:
            answerView.state = .warning
        case .error:
            answerView.state = .error
        }
        
        state = answerView.state
    }
}

// MARK: Private
private extension AnswerCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension AnswerCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            answerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.scale),
            answerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            answerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            answerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: Lazy initialization
private extension AnswerCell {
    func makeAnswerView() -> AnswerView {
        let view = AnswerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
