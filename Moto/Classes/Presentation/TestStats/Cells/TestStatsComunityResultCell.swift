//
//  TestStatsComunityResultCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 29.03.2021.
//

import UIKit

class TestStatsComunityResultCell: UITableViewCell {
    
    private lazy var timeView = makeComunityLineView()
    private lazy var averageView = makeComunityLineView()
    private lazy var scoreView = makeComunityLineView()
    private lazy var firstSeparator = makeSeparatorView()
    private lazy var secondSeparator = makeSeparatorView()
    private lazy var stackView = makeStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(element: TestStatsComunityResult) {
        timeView.setup(name: "TestStats.TestTime".localized, value: element.userTime)
        averageView.setup(name: "TestStats.ComunityAverage".localized, value: element.communityAverage)
        scoreView.setup(name: "TestStats.ComunityScore".localized, value: element.communityScore)
    }
}

// MARK: Private
private extension TestStatsComunityResultCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
        
        [timeView, makeSeparatorView(), averageView, makeSeparatorView(), scoreView].forEach(stackView.addArrangedSubview)
    }
}

// MARK: Make constraints
private extension TestStatsComunityResultCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44.scale),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.scale),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44.scale),
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsComunityResultCell {
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 22.scale
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = TestStatsPalette.CommunityResult.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1.scale).isActive = true
        return view
    }
    
    func makeComunityLineView() -> TestComunityResultLineView {
        let view = TestComunityResultLineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
