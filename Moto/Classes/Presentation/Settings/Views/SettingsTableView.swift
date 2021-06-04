//
//  SettingsTableView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import RxCocoa

final class SettingsTableView: UITableView {
    enum Tapped {
        case unlock, rateUs, contactUs, termsOfUse, privacyPoliicy, locale
    }
    
    lazy var tapped = PublishRelay<Tapped>()
    
    private lazy var sections = [SettingsTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension SettingsTableView {
    func setup(sections: [SettingsTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .links, .unlockPremium:
            return 1
        case .settings(let change):
            return change.count
        case .locale(let locales):
            return locales.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .unlockPremium:
            let cell = dequeueReusableCell(withIdentifier: String(describing: STUnlockCell.self), for: indexPath) as! STUnlockCell
            cell.tapped = { [weak self] in
                self?.tapped.accept(.unlock)
            }
            return cell
        case .links:
            let cell = dequeueReusableCell(withIdentifier: String(describing: STLinksCell.self), for: indexPath) as! STLinksCell
            cell.tapped = { [weak self] value in
                self?.tapped.accept(value)
            }
            return cell
        case .settings(let changes):
            let cell = dequeueReusableCell(withIdentifier: String(describing: STSettingLinksCell.self), for: indexPath) as! STSettingLinksCell
            cell.setup(change: changes[indexPath.row])
            cell.tapped = { [weak self] value in
                self?.tapped.accept(value)
            }
            return cell
        case .locale(let locales):
            let cell = dequeueReusableCell(withIdentifier: String(describing: STLocaleCell.self), for: indexPath) as! STLocaleCell
            cell.setup(title: locales[indexPath.row].0, value: locales[indexPath.row].1)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .unlockPremium:
            return 81.scale
        case .links, .settings, .locale:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        register(STUnlockCell.self, forCellReuseIdentifier: String(describing: STUnlockCell.self))
        register(STLinksCell.self, forCellReuseIdentifier: String(describing: STLinksCell.self))
        register(STSettingLinksCell.self, forCellReuseIdentifier: String(describing: STSettingLinksCell.self))
        register(STLocaleCell.self, forCellReuseIdentifier: String(describing: STLocaleCell.self))
        
        dataSource = self
        delegate = self
    }
}
