//
//  SCBriefDaysView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 13.02.2021.
//

import UIKit

final class SCBriefDaysView: UIView {
    lazy var stackView = makeStackView()
    lazy var briefDay1View = makeBriefDayView()
    lazy var briefDay2View = makeBriefDayView()
    lazy var briefDay3View = makeBriefDayView()
    lazy var briefDay4View = makeBriefDayView()
    lazy var briefDay5View = makeBriefDayView()
    lazy var briefDay6View = makeBriefDayView()
    lazy var briefDay7View = makeBriefDayView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var views: [SCBriefDayView] = {
        [
            briefDay1View,
            briefDay2View,
            briefDay3View,
            briefDay4View,
            briefDay5View,
            briefDay6View,
            briefDay7View
        ]
    }()
}

// MARK: API
extension SCBriefDaysView {
    func setup(calendar: [SCEBrief.Day]) {
        calendar.prefix(views.count).enumerated().forEach { stub in
            let (index, day) = stub
            
            views[index].setup(day: day)
        }
    }
}

// MARK: Make constraints
private extension SCBriefDaysView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SCBriefDaysView {
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16.scale
        view.backgroundColor = UIColor.clear
        views.forEach(view.addArrangedSubview(_:))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBriefDayView() -> SCBriefDayView {
        let view = SCBriefDayView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
