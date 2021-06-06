//
//  OSlide8View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideCountView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var slider = makeSlider()
    lazy var button = makeButton()
    
    private lazy var valueLabel = makeValueLabel()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        update(sender: slider)
    }
}

// MARK: Private
private extension OSlideCountView {
    @objc
    func update(sender: UISlider) {
        sender.value = round(sender.value)
        
        if slider.value <= 2 {
            imageView.image = UIImage(named: "Onboarding.SlideCount.Image1")
        } else if slider.value <= 5 {
            imageView.image = UIImage(named: "Onboarding.SlideCount.Image2")
        } else {
            imageView.image = UIImage(named: "Onboarding.SlideCount.Image3")
        }
        
        valueLabel.text = sender.value >= 7 ? "7+" : String(Int(sender.value))
        valueLabel.sizeToFit()
        
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: roundf(sender.value))
        valueLabel.center = CGPoint(x: thumbRect.midX, y: sender.frame.minY - valueLabel.frame.height)
    }
}

// MARK: Make constraints
private extension OSlideCountView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 250.scale : 230.scale),
            imageView.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: ScreenSize.isIphoneXFamily ? -87.scale : -40.scale)
        ])
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            slider.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -56.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideCountView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.bold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideCount.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.textColor = Onboarding.primaryText
        view.font = Fonts.SFProRounded.bold(size: 32.scale)
        addSubview(view)
        return view
    }
    
    func makeSlider() -> OSlider {
        let view = OSlider()
        view.minimumValue = 1
        view.maximumValue = 7
        view.minimumTrackTintColor = Onboarding.Slider.minimumTrackTint
        view.maximumTrackTintColor = Onboarding.Slider.maximumTrackTint
        view.addTarget(self, action: #selector(update(sender:)), for: .valueChanged)
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
        view.layer.cornerRadius = 20.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
