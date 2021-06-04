//
//  TestProgressView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 28.03.2021.
//

import UIKit

class TestProgressView: UIView {
    
    private lazy var leftTitle = makeTitleLabel()
    private lazy var rightTitle = makeTitleLabel()
    private lazy var leftContent = makeContentLabel()
    private lazy var rightContent = makeContentLabel()
    private lazy var leftContentView = makeBackgroundView()
    private lazy var rightContentView = makeBackgroundView()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension TestProgressView {
    func setRightContent(value: String, isError: Bool) {
        rightContent.attributedText = value.attributed(with: .contentAttr(isError))
    }
    
    func setLeftContent(value: String) {
        leftContent.attributedText = value.attributed(with: .contentAttr())
    }
    
    func setup(leftTitle: String, rightTitle: String) {
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textColor(ScorePalette.title)
            .textAlignment(.center)
        
        self.leftTitle.attributedText = leftTitle.attributed(with: attr)
        self.rightTitle.attributedText = rightTitle.attributed(with: attr)
    }
}

// MARK: Private
private extension TestProgressView {
    func initialize() {
        leftContentView.addSubview(leftContent)
        rightContentView.addSubview(rightContent)
        backgroundColor = ScorePalette.background
        layer.cornerRadius = 20.scale
    }
}

// MARK: Make constraints
private extension TestProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            leftTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            leftTitle.leadingAnchor.constraint(equalTo: leftContentView.leadingAnchor),
            leftTitle.trailingAnchor.constraint(equalTo: leftContentView.trailingAnchor),
            leftTitle.bottomAnchor.constraint(equalTo: leftContentView.topAnchor, constant: -4.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            rightTitle.leadingAnchor.constraint(equalTo: rightContentView.leadingAnchor),
            rightTitle.trailingAnchor.constraint(equalTo: rightContentView.trailingAnchor),
            rightTitle.bottomAnchor.constraint(equalTo: rightContentView.topAnchor, constant: -4.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftContentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24.scale),
            leftContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale),
            leftContentView.rightAnchor.constraint(equalTo: rightContentView.leftAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftContent.leadingAnchor.constraint(equalTo: leftContentView.leadingAnchor, constant: 16.scale),
            leftContent.trailingAnchor.constraint(equalTo: leftContentView.trailingAnchor, constant: -16.scale),
            leftContent.topAnchor.constraint(equalTo: leftContentView.topAnchor, constant: 10.scale),
            leftContent.bottomAnchor.constraint(equalTo: leftContentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale),
            rightContentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightContent.leadingAnchor.constraint(equalTo: rightContentView.leadingAnchor, constant: 16.scale),
            rightContent.trailingAnchor.constraint(equalTo: rightContentView.trailingAnchor, constant: -16.scale),
            rightContent.topAnchor.constraint(equalTo: rightContentView.topAnchor, constant: 10.scale),
            rightContent.bottomAnchor.constraint(equalTo: rightContentView.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TestProgressView {
    func makeBackgroundView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = ScorePalette.containerBackground
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContentLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

private extension TextAttributes {
    static func contentAttr(_ isError: Bool = false) -> TextAttributes {
        let color = isError
            ? ScorePalette.progressWarning
            : ScorePalette.progress
        
        return TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .lineHeight(28.scale)
            .textColor(color)
            .textAlignment(.center)
    }
}
