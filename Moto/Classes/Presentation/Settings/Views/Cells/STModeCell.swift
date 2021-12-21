//
//  STModeCell.swift
//  Moto
//
//  Created by Андрей Чернышев on 21.12.2021.
//

import UIKit

final class STModeCell: UITableViewCell {
    var tapped: ((SettingsTableView.Tapped) -> Void)?
    
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var valueLabel = makeValueLabel()
    
    private var mode: TestMode?
    
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
extension STModeCell {
    func setup(mode: TestMode) {
        self.mode = mode
        
        let attrs = TextAttributes()
            .font(Fonts.Lato.regular(size: 18.scale))
            .lineHeight(25.scale)
            .textColor(SettingsPalette.progress)
        let string = value(at: mode).attributed(with: attrs)
        valueLabel.attributedText = string
    }
}

// MARK: Private
private extension STModeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard let mode = mode else {
            return
        }
        
        tapped?(.mode(mode))
    }
    
    func value(at mode: TestMode) -> String {
        switch mode {
        case .fullComplect:
            return "Onboarding.Mode.Cell2.Title".localized
        case .noExplanations:
            return "Onboarding.Mode.Cell1.Title".localized
        case .onAnExam:
            return "Onboarding.Mode.Cell3.Title".localized
        }
    }
}

// MARK: Make constraints
private extension STModeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 57.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension STModeCell {
    func makeContainer() -> UIView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = SettingsPalette.itemBackground
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 18.scale))
            .lineHeight(25.scale)
            .textColor(SettingsPalette.itemTitle)
        
        let view = UILabel()
        view.attributedText = "Settings.Mode".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
