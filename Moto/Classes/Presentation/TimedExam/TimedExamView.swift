//
//  TimedExamView.swift
//  DMV
//
//  Created by Vitaliy Zagorodnov on 02.06.2021.
//
import UIKit

final class TimedExamView: UIView {
    
    private lazy var container = makeContainer()
    lazy var title = makeTitle()
    lazy var subtitle = makeSubtitle()
    lazy var closeButton = makeCloseButton()
    lazy var slider = makeSlider()
    lazy var startButton = makeStartButton()
    private lazy var valueLabel = makeValueLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        update(sender: slider)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TimedExamView {
    func initialize() {
        
    }
    
    @objc func update(sender: UISlider) {
        sender.value = round(sender.value)
        
        valueLabel.text = String(Int(sender.value))
        valueLabel.sizeToFit()
        
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: roundf(sender.value))
        valueLabel.center = CGPoint(x: thumbRect.midX, y: sender.frame.minY - valueLabel.frame.height)
    }
}

// MARK: Make constraints
private extension TimedExamView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60.scale)
        ])
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 23.scale),
            title.centerXAnchor.constraint(equalTo: container.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 28.scale),
            subtitle.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 102.scale),
            slider.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            slider.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 40.scale),
            startButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            startButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            startButton.heightAnchor.constraint(equalToConstant: 60.scale),
            startButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TimedExamView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = TimedExamPalette.background
        view.layer.cornerRadius = 30.scale
        addSubview(view)
        return view
    }
    
    func makeTitle() -> UILabel {
        let view = UILabel()
        view.font = Fonts.SFProRounded.regular(size: 16.scale)
        view.textColor = TimedExamPalette.title
        view.text = "TimedExam.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubtitle() -> UILabel {
        let view = UILabel()
        view.font = Fonts.SFProRounded.bold(size: 24.scale)
        view.textColor = TimedExamPalette.subtitle
        view.text = "TimedExam.Subtitle".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "General.Close"), for: .normal)
        view.tintColor = TimedExamPalette.closeTint
        container.addSubview(view)
        return view
    }
    
    func makeSlider() -> OSlider {
        let view = OSlider()
        view.minimumValue = 1
        view.maximumValue = 10
        view.value = 3
        view.minimumTrackTintColor = Onboarding.Slider.minimumTrackTint
        view.maximumTrackTintColor = Onboarding.Slider.maximumTrackTint
        view.addTarget(self, action: #selector(update(sender:)), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.textColor = Onboarding.primaryText
        view.font = Fonts.SFProRounded.bold(size: 32.scale)
        container.addSubview(view)
        return view
    }
    
    func makeStartButton() -> UIButton {
        let view = UIButton()
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(TimedExamPalette.startButtonTint)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = TimedExamPalette.startButton
        view.setAttributedTitle("TimedExam.Button".localized.attributed(with: attr), for: .normal)
        container.addSubview(view)
        return view
    }
}
