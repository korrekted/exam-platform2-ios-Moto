//
//  CourseDetailsTabelView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 24.04.2021.
//

import UIKit
import RxCocoa

class CourseDetailsTabelView: UIView {
    private lazy var tableView = makeTableView()
    private var elements = [CourseDetailsTableElement]()
    
    let didTapLearnMore = PublishRelay<Void>()
    let selectedTestId = PublishRelay<Int>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CourseDetailsTabelView {
    func setup(elements: [CourseDetailsTableElement]) {
        self.elements = elements
        tableView.reloadData()
    }
}

extension CourseDetailsTabelView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case let .test(element):
            selectedTestId.accept(element.id)
        case .needPayment:
            didTapLearnMore.accept(())
        }
    }
}

extension CourseDetailsTabelView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case .test(let config):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CourseDetailsTestCell.self), for: indexPath) as! CourseDetailsTestCell
            cell.setup(config: config)
            return cell
        case .needPayment:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrophyCell.self), for: indexPath) as! TrophyCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
}

private extension CourseDetailsTabelView {
    func initialize() {
        tableView.register(TrophyCell.self, forCellReuseIdentifier: String(describing: TrophyCell.self))
        tableView.register(CourseDetailsTestCell.self, forCellReuseIdentifier: String(describing: CourseDetailsTestCell.self))
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}

private extension CourseDetailsTabelView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

private extension CourseDetailsTabelView {
    func makeTableView() -> UITableView {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
