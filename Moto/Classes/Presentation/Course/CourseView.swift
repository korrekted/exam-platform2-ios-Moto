//
//  CourseView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class CourseView: UIView {
    lazy var container = makeContainer()
    lazy var tabView = makeTabView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension CourseView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: tabView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 83.scale : 60.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CourseView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = CoursePalette.background
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTabView() -> TabView {
        let view = TabView()
        view.backgroundColor = CoursePalette.background
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
