//
//  CourseDetailsView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 24.04.2021.
//

import UIKit

class CourseDetailsView: UIView {
    lazy var tableView = makeTableView()
    lazy var navigationView = makeNavigationView()
    lazy var progressView = makeProgressView()
    lazy var savedButton = makeButton(title: "CourseDetails.Saved".localized, icon: UIImage(named: "CourseDetails.Saved"))
    lazy var incorrectButton = makeButton(title: "CourseDetails.Incorrect".localized, icon: UIImage(named: "CourseDetails.Incorrect"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CourseDetailsView {
    
}

// MARK: Private
private extension CourseDetailsView {
    func initialize() {
        backgroundColor = CourseDetailsPalette.background
    }
}

// MARK: Make constraints
private extension CourseDetailsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 192.scale)
        ])
        
        NSLayoutConstraint.activate([
            savedButton.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 24.scale),
            savedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            savedButton.widthAnchor.constraint(equalToConstant: 127.scale),
            savedButton.heightAnchor.constraint(equalToConstant: 49.scale)
        ])
        
        NSLayoutConstraint.activate([
            incorrectButton.topAnchor.constraint(equalTo: savedButton.topAnchor),
            incorrectButton.bottomAnchor.constraint(equalTo: savedButton.bottomAnchor),
            incorrectButton.widthAnchor.constraint(equalToConstant: 154.scale),
            incorrectButton.leadingAnchor.constraint(equalTo: savedButton.trailingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            progressView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -32.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tableView.topAnchor.constraint(equalTo: savedButton.bottomAnchor, constant: 8.scale),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CourseDetailsView {
    func makeTableView() -> CourseDetailsTabelView {
        let view = CourseDetailsTabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationView() -> NavigationBar {
        let view = NavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAction.setImage(UIImage(named: "General.Pop"), for: .normal)
        view.leftAction.tintColor = NavigationPalette.navigationTint
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> ProgressView {
        let view = ProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle(title: "CourseDetails.PassRate".localized)
        addSubview(view)
        return view
    }
    
    func makeButton(title: String, icon: UIImage?) -> UIButton {
        let view = UIButton()
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(CourseDetailsPalette.primaryTint)
        
        view.setImage(icon, for: .normal)
        view.setAttributedTitle(title.attributed(with: attr), for: .normal)
        view.backgroundColor = CourseDetailsPalette.primaryButton
        view.contentEdgeInsets.left = -30.scale
        view.titleEdgeInsets.left = 8.scale
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
