//
//  MainStatsView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 25.01.2021.
//

import UIKit

class MainStatsView: UIView {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var containerView = makeContainerView()
    private lazy var percentLabel = makePercentLabel()
    private lazy var circleView = makeCircleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainStatsView {
    func setup(title: String, color: UIColor) {
        let titleAttibutes = TextAttributes()
            .textColor(StatsPalette.MainStats.title)
            .font(Fonts.SFProRounded.bold(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        titleLabel.attributedText = title.attributed(with: titleAttibutes)
        circleView.backgroundColor = color
    }
    
    func setPercent(percent: Int) {
        let percentAttributes = TextAttributes()
            .textColor(StatsPalette.MainStats.value)
            .font(Fonts.SFProRounded.bold(size: 24.scale))
            .lineHeight(28.8.scale)
        
        percentLabel.attributedText = "\(percent)%".attributed(with: percentAttributes)
    }
}

// MARK: Make constraints
private extension MainStatsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            circleView.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -4.scale),
            circleView.centerYAnchor.constraint(equalTo: percentLabel.centerYAnchor),
            circleView.heightAnchor.constraint(equalToConstant: 10.scale),
            circleView.widthAnchor.constraint(equalToConstant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            percentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            percentLabel.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
}
// MARK: Lazy initialization
private extension MainStatsView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCircleView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5.scale
        containerView.addSubview(view)
        return view
    }
}
