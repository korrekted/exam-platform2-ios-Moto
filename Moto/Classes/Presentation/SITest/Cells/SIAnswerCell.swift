//
//  SIAnswerCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 10.04.2021.
//

import UIKit

class SIAnswerCell: UITableViewCell {
    
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
extension SIAnswerCell {
    func setup(element: SIAnswerElement) {
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
private extension SIAnswerCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SIAnswerCell {
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
private extension SIAnswerCell {
    func makeAnswerView() -> AnswerView {
        let view = AnswerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
