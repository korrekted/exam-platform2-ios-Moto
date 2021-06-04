//
//  OSlide15View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import Lottie

final class OSlidePlanView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var chartView = makeChartView()
    lazy var cell1 = makeCell(title: "Onboarding.SlidePlan.Cell1", image: "Onboarding.SlidePlan.Cell1")
    lazy var cell2 = makeCell(title: "Onboarding.SlidePlan.Cell2", image: "Onboarding.SlidePlan.Cell2")
    lazy var cell3 = makeCell(title: "Onboarding.SlidePlan.Cell3", image: "Onboarding.SlidePlan.Cell3")
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        chartView.play()
    }
}

// MARK: Make constraints
private extension OSlidePlanView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 84.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            chartView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 222.scale : 150.scale),
            chartView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 307.scale : 265.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.bottomAnchor.constraint(equalTo: cell2.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.bottomAnchor.constraint(equalTo: cell3.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.bottomAnchor.constraint(equalTo: button.topAnchor, constant: ScreenSize.isIphoneXFamily ? -53.scale : -34.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlidePlanView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.bold(size: 24.scale))
            .lineHeight(28.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlidePlan.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeChartView() -> AnimationView {
        let view = AnimationView()
        view.animation = Animation.named("Onboarding.Chart")
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String, image: String) -> OSlidePlanCell {
        let view = OSlidePlanCell()
        view.label.text = title.localized
        view.imageView.image = UIImage(named: image)
        view.imageView.tintColor = Onboarding.Plan.icon
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryButtonTint)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Onboarding.primaryButton
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.SlidePlan.Button".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
