//
//  LocaleTableView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 25.05.2021.
//

import UIKit

final class LocaleTableView: UITableView {
    var tapped: (() -> Void)?
    
    lazy var elements = [LocaleTableViewElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LocaleTableView {
    func setup(elements: [LocaleTableViewElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension LocaleTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: LocaleTableViewCell.self)) as! LocaleTableViewCell
        cell.setup(element: elements[indexPath.section])
        return cell
    }
}

// MARK: UITableViewDelegate
extension LocaleTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements.forEach {
            $0.isSelected = false
        }
        elements[indexPath.section].isSelected = true
        
        reloadData()
        
        tapped?()
    }
}

// MARK: Private
private extension LocaleTableView {
    func initialize() {
        register(LocaleTableViewCell.self, forCellReuseIdentifier: String(describing: LocaleTableViewCell.self))
        
        dataSource = self
        delegate = self
    }
}
