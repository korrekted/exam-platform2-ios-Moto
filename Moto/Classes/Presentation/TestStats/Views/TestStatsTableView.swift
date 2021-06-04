//
//  TestStatsTableView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import UIKit
import RxCocoa

class TestStatsTableView: UITableView {
    lazy var selectedFilter = BehaviorRelay<TestStatsFilter>(value: .all)
    private var elements: [TestStatsCellType] = []

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension TestStatsTableView {
    func setup(elements: [TestStatsCellType]) {
        self.elements = elements
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension TestStatsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        
        switch element {
        case let .progress(element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsProgressCell.self), for: indexPath) as! TestStatsProgressCell
            cell.setup(element: element)
            return cell
        case let .description(element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsResultCell.self), for: indexPath) as! TestStatsResultCell
            cell.setup(element: element)
            return cell
        case let .filter(filter):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsFilterCell.self), for: indexPath) as! TestStatsFilterCell
            cell.setup(selectedFilter: filter) { [weak self] in
                self?.selectedFilter.accept($0)
            }
            return cell
        case let .answer(element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsAnswerCell.self), for: indexPath) as! TestStatsAnswerCell
            cell.setup(element: element)
            return cell
        case let .comunityResult(element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsComunityResultCell.self), for: indexPath) as! TestStatsComunityResultCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: Private
private extension TestStatsTableView {
    func initialize() {
        register(TestStatsProgressCell.self, forCellReuseIdentifier: String(describing: TestStatsProgressCell.self))
        register(TestStatsResultCell.self, forCellReuseIdentifier: String(describing: TestStatsResultCell.self))
        register(TestStatsFilterCell.self, forCellReuseIdentifier: String(describing: TestStatsFilterCell.self))
        register(TestStatsAnswerCell.self, forCellReuseIdentifier: String(describing: TestStatsAnswerCell.self))
        register(TestStatsComunityResultCell.self, forCellReuseIdentifier: String(describing: TestStatsComunityResultCell.self))
        
        dataSource = self
    }
}
