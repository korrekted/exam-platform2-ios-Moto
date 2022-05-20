//
//  OSlide1View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideWelcomeView: OSlideView {
    lazy var scrollView = makeScrollView()
    lazy var indicatorView = makeIndicatorView()
    lazy var button = makeButton()
    
    private lazy var buttonAttrs = TextAttributes()
        .textColor(Onboarding.primaryButtonTint)
        .font(Fonts.SFProRounded.semiBold(size: 20.scale))
        .textAlignment(.center)
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
        updateButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentViews: [UIView] = {
        [
            WelcomeSlide1View(), WelcomeSlide2View(), WelcomeSlide3View()
        ]
    }()
}

// MARK: Private
private extension OSlideWelcomeView {
    func initialize() {
        contentViews
            .enumerated()
            .forEach { index, view in
                scrollView.addSubview(view)
                
                view.frame.origin = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
            }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(contentViews.count),
                                        height: UIScreen.main.bounds.height)
        
        indicatorView.index = 1
    }
    
    @objc
    func didTapped() {
        indicatorView.index = indicatorView.index + 1
        
        guard indicatorView.index <= 3 else {
            onNext()
            return
        }
        
        scroll()
        updateButton()
    }
    
    func scroll() {
        let index = indicatorView.index - 1
        
        guard contentViews.indices.contains(index) else {
            return
        }
        
        let frame = contentViews[index].frame
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func updateButton() {
        let title = indicatorView.index == 3 ? "Onboarding.Welcome.GetStarted" : "Onboarding.Next"
        button.setAttributedTitle(title.localized.attributed(with: buttonAttrs), for: .normal)
    }
}

// MARK: Make constraints
private extension OSlideWelcomeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 8.scale),
            indicatorView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: ScreenSize.isIphoneXFamily ? -31.scale : -13.scale)
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
private extension OSlideWelcomeView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIndicatorView() -> WelcomeSlideIndicatorView {
        let view = WelcomeSlideIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = Onboarding.primaryButton
        view.layer.cornerRadius = 20.scale
        view.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
