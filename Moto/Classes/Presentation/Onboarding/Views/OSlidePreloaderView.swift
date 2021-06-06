//
//  OSlide14View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

final class OSlidePreloaderView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var progressView = makeProgressView()
    lazy var cell1 = makeCell(title: "Onboarding.Preloader.Cell1")
    lazy var cell2 = makeCell(title: "Onboarding.Preloader.Cell2")
    lazy var cell3 = makeCell(title: "Onboarding.Preloader.Cell3")
    
    private var timer: Timer?
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        progressView.progressAnimation(duration: 4.5)
        calculatePercent()
    }
}

// MARK: Private
private extension OSlidePreloaderView {
    func calculatePercent() {
        let duration = Double(4.5)
        var seconds = Double(0)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            seconds += 0.1
            
            var percent = Int(seconds / duration * 100)
            if percent > 100 {
                percent = 100
            }
            
            if percent <= 33 {
                self?.cell1.isChecked = true
            } else if percent <= 66 {
                self?.cell2.isChecked = true
            }  else {
                self?.cell3.isChecked = true
            }
            
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
    
    func initialize() {
        backgroundColor = Onboarding.Preloader.background
    }
}

// MARK: Make constraints
private extension OSlidePreloaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 153.scale : 89.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 150.scale : 80.scale),
            progressView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 150.scale : 80.scale),
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 88.scale : 66.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            cell1.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 88.scale : 66.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlidePreloaderView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.Preloader.text)
            .font(Fonts.SFProRounded.bold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Preloader.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> OProgressView {
        let view = OProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String) -> OPreloaderCell {
        let view = OPreloaderCell()
        view.title = title.localized
        view.isChecked = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
