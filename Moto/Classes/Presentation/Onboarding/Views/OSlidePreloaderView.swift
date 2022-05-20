//
//  OSlide14View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

final class OSlidePreloaderView: OSlideView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var progressView = makeProgressView()
    lazy var progressLabel = makeProgressLabel()
    
    private var timer: Timer?
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        calculatePercent()
    }
}

// MARK: Private
private extension OSlidePreloaderView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 101, blue: 1)
    }
    
    func calculatePercent() {
        let duration = Double(4.5)
        var seconds = Double(0)
        
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.bold(size: 18.scale))
            .lineHeight(25.2.scale)
            .textAlignment(.center)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            seconds += 0.1
            
            var percent = Int(seconds / duration * 100)
            if percent > 100 {
                percent = 100
            }
            
            if percent <= 33 {
                self?.progressLabel.attributedText = String(format: "Onboarding.Preloader.Cell1".localized, percent).attributed(with: attrs)
            } else if percent <= 66 {
                self?.progressLabel.attributedText = String(format: "Onboarding.Preloader.Cell2".localized, percent).attributed(with: attrs)
            }  else {
                self?.progressLabel.attributedText = String(format: "Onboarding.Preloader.Cell3".localized, percent).attributed(with: attrs)
            }
            
            self?.progressView.progress = Float(percent) / 100
            
            if seconds >= duration {
                timer.invalidate()
                
                self?.finish()
            }
        }
    }
    
    func finish() {
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.onNext()
        }
    }
}

// MARK: Make constraints
private extension OSlidePreloaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 236.scale),
            imageView.heightAnchor.constraint(equalToConstant: 365.scale),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            titleLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -68.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            progressView.heightAnchor.constraint(equalToConstant: 59.scale),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlidePreloaderView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Preloader.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Preloader.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.trackTintColor = UIColor(integralRed: 225, green: 89, blue: 0)
        view.progressTintColor = UIColor(integralRed: 31, green: 31, blue: 31)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
