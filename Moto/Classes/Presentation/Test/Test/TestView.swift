//
//  TestView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import UIKit

final class TestView: UIView {
    lazy var navigationView = makeNavigationView()
    lazy var counter = makeCounterView()
    lazy var tableView = makeTableView()
    lazy var bottomView = makeBottomView()
    lazy var preloader = makePreloader()
    
    private let testType: TestType
    
    init(testType: TestType) {
        self.testType = testType
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TestView {
    func initialize() {
        backgroundColor = TestPalette.background
    }
}

// MARK: Make constraints
private extension TestView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: testType.isQotd() ? 125.scale : 167.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            counter.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            counter.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 36.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 177.scale : 140.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestView {
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
    
    func makeCounterView() -> TestProgressView {
        let view = TestProgressView()
        view.isHidden = testType.isQotd()
        view.backgroundColor = ScorePalette.background
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> QuestionTableView {
        let view = QuestionTableView()
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(top: testType.isQotd() ? 0 : 36.scale,
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
    
    func makeBottomView() -> TestBottomView {
        let view = TestBottomView()
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
