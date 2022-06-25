//
//  SITestView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 07.04.2021.
//

import UIKit

final class SITestView: UIView {
    lazy var navigationView = makeNavigationView()
    lazy var collectionView = makeCollectionView()
    lazy var tableView = makeTableView()
    lazy var bottomView = makeBottomView()
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
private extension SITestView {
    func initialize() {
        backgroundColor = TestPalette.background
    }
}

// MARK: Make constraints
private extension SITestView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 125.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 75.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 2.scale),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 177.scale : 140.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SITestView {
    func makeNavigationView() -> NavigationBar {
        let view = NavigationBar()
        view.leftAction.setImage(UIImage(named: "General.Pop"), for: .normal)
        view.leftAction.tintColor = NavigationPalette.navigationTint
        view.rightAction.tintColor = NavigationPalette.navigationTint
        view.backgroundColor = NavigationPalette.navigationBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> SIProgressCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 9.scale
        
        let view = SIProgressCollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 0, left: 24.scale, bottom: 0, right: 24.scale)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> QuestionTableView {
        let view = QuestionTableView()
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(top: 18.scale,
                                         left: 0,
                                         bottom: ScreenSize.isIphoneXFamily ? 177.scale : 140.scale,
                                         right: 0)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> SITestBottomView {
        let view = SITestBottomView()
        view.backgroundColor = UIColor.clear
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
