//
//  StatsView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class StatsView: UIView {
    lazy var tableView = makeTableView()
    lazy var navigationView = makeNavigationView()
    lazy var progressView = makeProgressView()
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
private extension StatsView {
    func initialize() {
        backgroundColor = StatsPalette.background
    }
}

// MARK: Make constraints
private extension StatsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 179.scale : 155.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            progressView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -32.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tableView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension StatsView {
    func makeTableView() -> StatsTableView {
        let view = StatsTableView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationView() -> NavigationBar {
        let view = NavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isBigTitle = true
        view.setTitle(title: "Stats.Title".localized)
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> ProgressView {
        let view = ProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle(title: "Stats.PassRate.Title".localized)
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 60.scale, height: 60.scale), color: .blue)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

