//
//  QuestionTableView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class QuestionTableView: UITableView {
    let selectedAnswersRelay = PublishRelay<AnswerElement>()
    let expandContent = PublishRelay<QuestionContentCollectionType>()
    
    private lazy var elements = [TestingCellType]()
    
    private var selectedIds: (([Int]) -> Void)?
    private var isMultiple = false
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension QuestionTableView {
    func setup(question: QuestionElement) {
        selectedIds = { [weak self] elements in
            let element = AnswerElement(questionId: question.id, answerIds: elements, isMultiple: question.isMultiple)
            self?.selectedAnswersRelay.accept(element)
        }
        elements = question.elements
        isMultiple = question.isMultiple
        
        reloadData()
        
        let isBottomScroll = question.elements.contains(where: { element -> Bool in
            guard case .result = element else {
                return false
            }
            
            return true
        })
        
        let indexPath = IndexPath(row: isBottomScroll ? question.elements.count - 1 : 0, section: 0)
        scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

// MARK: UITableViewDataSource
extension QuestionTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .content(content):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableContentCell.self), for: indexPath) as! QuestionTableContentCell
            cell.configure(content: content) { [weak self] in
                self?.expandContent.accept($0)
            }
            return cell
        case let .question(question, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableQuestionCell.self), for: indexPath) as! QuestionTableQuestionCell
            cell.configure(question: question, questionHtml: html)
            return cell
        case let .answers(answers):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableAnswersCell.self), for: indexPath) as! QuestionTableAnswersCell
            cell.configure(answers: answers, isMultiple: isMultiple, didTap: selectedIds)
            return cell
        case .explanationTitle:
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableExplanationTitleCell.self), for: indexPath) as! QuestionTableExplanationTitleCell
            return cell
        case let .explanationImage(url):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableExplanationImageCell.self), for: indexPath) as! QuestionTableExplanationImageCell
            cell.confugure(image: url)
            return cell
        case let .explanationText(explanation, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableExplanationTextCell.self), for: indexPath) as! QuestionTableExplanationTextCell
            cell.confugure(explanation: explanation, html: html)
            return cell
        case let .result(elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableAnswersCell.self), for: indexPath) as! QuestionTableAnswersCell
            cell.configure(result: elements)
            return cell
        case let .reference(reference):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableQuestionReferenceCell.self), for: indexPath) as! QuestionTableQuestionReferenceCell
            cell.confugure(reference: reference)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension QuestionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .explanationImage(url) = elements[indexPath.row] else {
            return
        }
        
        expandContent.accept(.image(url))
    }
}

// MARK: Private
private extension QuestionTableView {
    func initialize() {
        register(QuestionTableContentCell.self, forCellReuseIdentifier: String(describing: QuestionTableContentCell.self))
        register(QuestionTableQuestionCell.self, forCellReuseIdentifier: String(describing: QuestionTableQuestionCell.self))
        register(QuestionTableAnswersCell.self, forCellReuseIdentifier: String(describing: QuestionTableAnswersCell.self))
        register(QuestionTableExplanationImageCell.self, forCellReuseIdentifier: String(describing: QuestionTableExplanationImageCell.self))
        register(QuestionTableExplanationTextCell.self, forCellReuseIdentifier: String(describing: QuestionTableExplanationTextCell.self))
        register(QuestionTableExplanationTitleCell.self, forCellReuseIdentifier: String(describing: QuestionTableExplanationTitleCell.self))
        register(QuestionTableQuestionReferenceCell.self, forCellReuseIdentifier: String(describing: QuestionTableQuestionReferenceCell.self))
        
        dataSource = self
        delegate = self
    }
}
