//
//  SCModesCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 15.04.2021.
//

import UIKit

class SCModesCell: UICollectionViewCell {
    
    private lazy var todayView = makeModeVew()
    private lazy var tenView = makeModeVew()
    private lazy var missedView = makeModeVew()
    private lazy var randomView = makeModeVew()
    private lazy var timeView = makeModeVew()
    
    var selectedMode: ((SCEMode.Mode) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SCModesCell {
    func setup() {
        todayView.setup(name: "Study.Mode.TodaysQuestion".localized, image: UIImage(named: "Study.Mode.Todays"), markMessage: "Study.Mode.TryMe".localized)
        randomView.setup(name: "Study.Mode.RandomSet".localized, image: UIImage(named: "Study.Mode.Random"))
        tenView.setup(name: "Study.Mode.TenQuestions".localized, image: UIImage(named: "Study.Mode.Ten"))
        missedView.setup(name: "Study.Mode.MissedQuestions".localized, image: UIImage(named: "Study.Mode.Missed"))
        timeView.setup(name: "Study.Mode.TimedQuizz".localized, image: UIImage(named: "Study.TimedQuiz"))
    }
}

// MARK: Private
private extension SCModesCell {
    func initialize() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    @objc func didSelectMode(sender: UITapGestureRecognizer) {
        guard let view = sender.view as? SCModeView else { return }
        
        if view === tenView {
            selectedMode?(.ten)
        } else if view === todayView {
            selectedMode?(.today)
        } else if view === randomView {
            selectedMode?(.random)
        } else if view === missedView {
            selectedMode?(.missed)
        } else if view === timeView {
            selectedMode?(.time)
        }
    }
    
    
}

// MARK: Make constraints
private extension SCModesCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            todayView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            todayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            todayView.widthAnchor.constraint(equalTo: randomView.widthAnchor),
            todayView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            randomView.topAnchor.constraint(equalTo: todayView.bottomAnchor, constant: 16.scale),
            randomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            randomView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            randomView.trailingAnchor.constraint(equalTo: todayView.trailingAnchor),
            randomView.heightAnchor.constraint(equalToConstant: 148)
        ])
        
        NSLayoutConstraint.activate([
            tenView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            tenView.leadingAnchor.constraint(equalTo: todayView.trailingAnchor, constant: 16.scale),
            tenView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            tenView.widthAnchor.constraint(equalTo: todayView.widthAnchor, multiplier: 0.95)
        ])
        
        NSLayoutConstraint.activate([
            missedView.topAnchor.constraint(equalTo: tenView.bottomAnchor, constant: 16.scale),
            missedView.leadingAnchor.constraint(equalTo: randomView.trailingAnchor, constant: 16.scale),
            missedView.heightAnchor.constraint(equalTo: tenView.heightAnchor),
            missedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            missedView.widthAnchor.constraint(equalTo: tenView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeView.topAnchor.constraint(equalTo: missedView.bottomAnchor, constant: 16.scale),
            timeView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -6.scale),
            timeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            timeView.widthAnchor.constraint(equalTo: missedView.widthAnchor),
            timeView.heightAnchor.constraint(equalTo: tenView.heightAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SCModesCell {
    func makeModeVew() -> SCModeView {
        let view = SCModeView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectMode))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = StudyPalette.Mode.background
        contentView.addSubview(view)
        return view
    }
}
