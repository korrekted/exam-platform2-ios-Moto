//
//  STSettingLinksCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 16.04.2021.
//

import UIKit

final class STSettingLinksCell: UITableViewCell {
    var tapped: ((SettingsTableView.Tapped) -> Void)?
    
    lazy var changeTopicsView = makeChangeTopicsView()
    
    private var change: SettingsTableSection.Change?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Pubilc
extension STSettingLinksCell {
    func setup(change: SettingsTableSection.Change) {
        self.change = change
        
        let string: String
        switch change {
        case .locale:
            string = "Settings.ChangeLocale".localized
        }
        
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 18.scale))
            .lineHeight(25.scale)
            .textColor(SettingsPalette.itemTitle)
        
        changeTopicsView.label.attributedText = string.attributed(with: attrs)
    }
}

// MARK: Private
private extension STSettingLinksCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard let change = self.change else {
            return
        }
        
        switch change {
        case .locale:
            tapped?(.locale)
        }
    }
}

// MARK: Make constraints
private extension STSettingLinksCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            changeTopicsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            changeTopicsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            changeTopicsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            changeTopicsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension STSettingLinksCell {
    func makeChangeTopicsView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
