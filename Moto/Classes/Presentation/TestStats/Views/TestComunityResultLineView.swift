//
//  TestComunityResultLineView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 29.03.2021.
//

import UIKit

class TestComunityResultLineView: UIView {
    private lazy var valueLabel = makeValueLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension TestComunityResultLineView {
    func setup(name: String, value: String) {
        subtitleLabel.attributedText = name.attributed(with: .subtitleAttr)
        valueLabel.attributedText = value.attributed(with: .valueAttr)
    }
}

// MARK: Make constraints
private extension TestComunityResultLineView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4.scale),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestComunityResultLineView {
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 2
        addSubview(view)
        return view
    }
}


// MARK: Private
private extension TextAttributes {
    static let valueAttr = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 24.scale))
        .textColor(TestStatsPalette.CommunityResult.value)
        .textAlignment(.center)
        .lineHeight(28.8.scale)
    
    static let subtitleAttr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 14.scale))
        .textColor(TestStatsPalette.CommunityResult.subtitle)
        .textAlignment(.center)
        .lineHeight(19.6.scale)
}
