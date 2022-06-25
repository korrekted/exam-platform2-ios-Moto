//
//  AnswerCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import UIKit
import RxSwift

final class QuestionTableAnswersCell: UITableViewCell {
    lazy var stackView = makeStackView()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

// MARK: Public
extension QuestionTableAnswersCell {
    func configure(answers: [PossibleAnswerElement], isMultiple: Bool, didTap: (([Int]) -> Void)?) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        let answersElements = answers.enumerated().map { (makeAnswerView(answer: $1.answer,
                                                                         answerHtml: $1.answerHtml,
                                                                         image: $1.image), $1) }
        answersElements.map { $0.0 }.forEach(stackView.addArrangedSubview)
        setNeedsLayout()
        
        let test = answersElements
            .map { answerView, element in
                answerView.didTap
                    .asObservable()
                    .scan(false) { _, _ in answerView.state != .selected }
                    .do(onNext: { isSelected in
                        if isMultiple {
                            answerView.state = isSelected && isMultiple ? .selected : .initial
                        } else {
                            answersElements.forEach { view, _ in
                                if view === answerView {
                                    answerView.state = isSelected ? .selected : .initial
                                } else {
                                    view.state = .initial
                                }
                            }
                        }
                    })
                    .map { ($0, element) }
            }
        
        Observable.merge(test)
            .scan(Set<PossibleAnswerElement>(), accumulator: { (old, args) -> Set<PossibleAnswerElement> in
                let (isSelected, element) = args
                
                guard isMultiple else { return isSelected ? [element] : [] }
                
                var result = old
                
                if isSelected {
                    result.insert(element)
                } else {
                    result.remove(element)
                }
                
                return result
            })
            .map { $0.map { $0.id } }
            .subscribe(onNext: didTap)
            .disposed(by: disposeBag)
    }
    
    func configure(result: [AnswerResultElement]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let views = result.enumerated().map { index, element -> AnswerView in
            let view = makeAnswerView(answer: element.answer,
                                      answerHtml: element.answerHtml,
                                      image: element.image)
            view.isUserInteractionEnabled = false
            switch element.state {
            case .initial:
                view.state = .initial
            case .correct:
                view.state = .correct
            case .error:
                view.state = .error
            case .warning:
                view.state = .warning
            }
            
            return view
        }
        
        views.forEach(stackView.addArrangedSubview)
        setNeedsLayout()
    }
}

// MARK: Private
private extension QuestionTableAnswersCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension QuestionTableAnswersCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        let anchor = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        anchor.priority = .init(999)
        anchor.isActive = true
    }
}

// MARK: Lazy initialization
private extension QuestionTableAnswersCell {
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.spacing = 10.scale
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeAnswerView(answer: String?, answerHtml: String?, image: URL?) -> AnswerView {
        let view = AnswerView()
        if let answerHtml = answerHtml {
            view.setAnswer(answerHtml: answerHtml, image: image)
        } else if let answer = answer {
            view.setAnswer(answer: answer, image: image)
        }
        return view
    }
}
