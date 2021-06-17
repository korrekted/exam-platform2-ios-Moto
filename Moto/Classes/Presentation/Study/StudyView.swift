//
//  StudyView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class StudyView: UIView {
    lazy var collectionView = makeCollectionView()
    lazy var navigationView = makeNavigationView()
    lazy var briefDaysView = makeBriefDaysView()
    lazy var streakLabel = makeStreakLabel()
    lazy var takeButton = makeButton()
    lazy var unlockButton = makeButton()
    private lazy var stackView = makeStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension StudyView {
    func setup(brief element: SCEBrief) {
        let streakDays = String.choosePluralForm(byNumber: element.streakDays,
                                                 one: "Study.Day.One".localized,
                                                 two: "Study.Day.Two".localized,
                                                 many: "Study.Day.Many".localized)
        streakLabel.text = String(format: "%i %@ %@", element.streakDays, streakDays, "Study.Streak".localized)
        
        briefDaysView.setup(calendar: element.calendar)
    }
    
    func setupButtons(_ activeSubscription: Bool) {
        unlockButton.setAttributedTitle("Study.UnlockQuestions".localized.attributed(with: .unlockAttrs), for: .normal)
        unlockButton.backgroundColor = StudyPalette.primaryButton
        
        let text = activeSubscription ? "Study.TakeTest".localized : "Study.TakeFreeTest".localized
        let textColor = activeSubscription ? StudyPalette.primaryButtonText : StudyPalette.secondaryButtonText
        takeButton.setAttributedTitle(text.attributed(with: TextAttributes.takeAttrs.textColor(textColor)), for: .normal)
        
        takeButton.backgroundColor = activeSubscription ? StudyPalette.primaryButton : StudyPalette.secondaryButton
        
        unlockButton.isHidden = activeSubscription
    }
}

// MARK: Private
private extension StudyView {
    func initialize() {
        backgroundColor = StudyPalette.background
    }
}

// MARK: Make constraints
private extension StudyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 351.scale : 335.scale)
        ])
        
        NSLayoutConstraint.activate([
            briefDaysView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            briefDaysView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            briefDaysView.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            streakLabel.topAnchor.constraint(equalTo: briefDaysView.bottomAnchor, constant: 8.scale),
            streakLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            streakLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: streakLabel.bottomAnchor, constant: 16.scale),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            stackView.heightAnchor.constraint(equalToConstant: 110.scale),
            stackView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -32.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension StudyView {
    func makeCollectionView() -> StudyCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16.scale
        
        let view = StudyCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationView() -> NavigationBar {
        let view = NavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NavigationPalette.navigationBackground
        view.isBigTitle = true
        view.setTitle(title: "Study.Title".localized)
        view.rightAction.setImage(UIImage(named: "Study.Settings"), for: .normal)
        view.rightAction.tintColor = NavigationPalette.navigationTint
        addSubview(view)
        return view
    }
    
    func makeBriefDaysView() -> SCBriefDaysView {
        let view = SCBriefDaysView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStreakLabel() -> UILabel {
        let view = UILabel()
        view.font = Fonts.SFProRounded.regular(size: 14.scale)
        view.textAlignment = .right
        view.textColor = StudyPalette.Brief.text
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 12.scale
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 25.scale
        stackView.addArrangedSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let takeAttrs = TextAttributes()
        .font(Fonts.SFProRounded.medium(size: 18.scale))
    
    static let unlockAttrs = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 18.scale))
        .textColor(StudyPalette.primaryButtonText)
}
