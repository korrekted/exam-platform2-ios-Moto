//
//  SITestTableView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 10.04.2021.
//

import UIKit
import RxCocoa

class SITestTableView: UITableView {
    private lazy var elements = [SITestCellType]()
    let selectedAnswers = PublishRelay<[SIAnswerElement]>()
    
    private var selectedCells: Set<IndexPath> = [] {
        didSet {
            let answers = selectedCells
                .compactMap { indexPath -> SIAnswerElement? in
                    guard case let .answer(answer) = elements[safe: indexPath.row] else { return nil }
                    return answer
                }
            
            selectedAnswers.accept(answers)
        }
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SITestTableView {
    func setup(question: SIQuestionElement) {
        elements = question.elements
        allowsMultipleSelection = question.isMultiple
        allowsSelection = !question.isResult
        selectedCells.removeAll()
        CATransaction.setCompletionBlock { [weak self] in
            let indexPath = IndexPath(row: question.isResult ? question.elements.count - 1 : 0, section: 0)
            self?.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        CATransaction.begin()
        reloadData()
        CATransaction.commit()
    }
}

// MARK: UITableViewDelegate
extension SITestTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath) is SIAnswerCell ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SIAnswerCell else { return }
        
        if selectedCells.contains(indexPath) {
            selectedCells.remove(indexPath)
            cell.setSelected(false, animated: false)
        } else {
            if isMultipleTouchEnabled {
                selectedCells.insert(indexPath)
            } else {
                selectedCells = [indexPath]
            }
            cell.setSelected(true, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is SIAnswerCell, selectedCells.contains(indexPath) {
            cell.setSelected(true, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if case .content = elements[indexPath.row] {
            return 213.scale
        } else {
            return UITableView.automaticDimension
        }
    }
}

// MARK: UITableViewDataSource
extension SITestTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        
        switch element {
        case let .content(content):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionContentCell.self), for: indexPath) as! QuestionContentCell
            cell.configure(content: content)
            return cell
        case let .question(question, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SIQuestionCell.self), for: indexPath) as! SIQuestionCell
            cell.configure(question: question, questionHtml: html)
            return cell
        case let .answer(answer):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SIAnswerCell.self), for: indexPath) as! SIAnswerCell
            cell.setup(element: answer)
            return cell
        case let .explanation(explanation):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExplanationCell.self), for: indexPath) as! ExplanationCell
            cell.confugure(explanation: explanation)
            return cell
        }
    }
}

// MARK: Private
private extension SITestTableView {
    func initialize() {
        register(QuestionContentCell.self, forCellReuseIdentifier: String(describing: QuestionContentCell.self))
        register(SIAnswerCell.self, forCellReuseIdentifier: String(describing: SIAnswerCell.self))
        register(SIQuestionCell.self, forCellReuseIdentifier: String(describing: SIQuestionCell.self))
        register(ExplanationCell.self, forCellReuseIdentifier: String(describing: ExplanationCell.self))
        separatorStyle = .none
        
        dataSource = self
        delegate = self
    }
}
