//
//  FlashcardsView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import UIKit

final class FlashcardsView: UIView {
    lazy var navigationView = makeNavigationView()
    lazy var flashCardContainer = makeFlashCardContainer()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension FlashcardsView {
    func initialize() {
        backgroundColor = FlashcardPalette.background
    }
}

// MARK: Make constraints
private extension FlashcardsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 125.scale)
        ])
        
        NSLayoutConstraint.activate([
            flashCardContainer.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            flashCardContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            flashCardContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            flashCardContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FlashcardsView {
    func makeNavigationView() -> NavigationBar {
        let view = NavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NavigationPalette.navigationBackground
        view.leftAction.setImage(UIImage(named: "General.Pop"), for: .normal)
        view.leftAction.tintColor = NavigationPalette.navigationTint
        addSubview(view)
        return view
    }
    
    func makeFlashCardContainer() -> FlashCardContainerView {
        let view = FlashCardContainerView()
        view.backgroundColor = FlashcardPalette.background
        view.inset = UIEdgeInsets(
            top: 24.scale,
            left: 20.scale,
            bottom: ScreenSize.isIphoneXFamily ? 73.scale : 43.scale,
            right: 20.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 60.scale, height: 60.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
