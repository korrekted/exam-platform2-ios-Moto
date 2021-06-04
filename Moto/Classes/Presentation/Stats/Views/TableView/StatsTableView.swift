//
//  StatsTableView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 27.01.2021.
//

import UIKit
import RxCocoa

final class StatsTableView: UITableView {
    private lazy var elements = [StatsCellType]()
    lazy var didTapLearnMore = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension StatsTableView {
    func setup(elements: [StatsCellType]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDelegate
extension StatsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .needPayment = elements[indexPath.row] else { return }
        didTapLearnMore.accept(())
    }
}

// MARK: UITableViewDataSource
extension StatsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .main(value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: MainRateCell.self), for: indexPath) as! MainRateCell
            cell.setup(model: value)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case let .course(value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CourseProgressCell.self), for: indexPath) as! CourseProgressCell
            cell.setup(model: value)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case .needPayment:
            let cell = dequeueReusableCell(withIdentifier: String(describing: TrophyCell.self), for: indexPath) as! TrophyCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: Private
private extension StatsTableView {
    func initialize() {
        register(MainRateCell.self, forCellReuseIdentifier: String(describing: MainRateCell.self))
        register(CourseProgressCell.self, forCellReuseIdentifier: String(describing: CourseProgressCell.self))
        register(TrophyCell.self, forCellReuseIdentifier: String(describing: TrophyCell.self))
        separatorStyle = .none
        
        dataSource = self
    }
}
