//
//  FlashcardsTableView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import UIKit
import RxCocoa

final class FlashcardsTopicsTableView: UITableView {
    var didTappedRelay = PublishRelay<FlashcardTopic>()
    
    lazy var flashcards = [FlashcardTopic]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension FlashcardsTopicsTableView {
    func setup(flashcards: [FlashcardTopic]) {
        self.flashcards = flashcards
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension FlashcardsTopicsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        flashcards.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: FlashcardsTopicsTableCell.self)) as! FlashcardsTopicsTableCell
        cell.setup(flashcard: flashcards[indexPath.section])
        return cell
    }
}

// MARK: UITableViewDelegate
extension FlashcardsTopicsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTappedRelay.accept(flashcards[indexPath.section])
    }
}

// MARK: Private
private extension FlashcardsTopicsTableView {
    func initialize() {
        register(FlashcardsTopicsTableCell.self, forCellReuseIdentifier: String(describing: FlashcardsTopicsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
