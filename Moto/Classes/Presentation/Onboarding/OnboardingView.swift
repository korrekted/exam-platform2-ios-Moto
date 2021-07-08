//
//  OnboardingView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class OnboardingView: UIView {
    enum Step: Int {
        case welcome, locale, experience, goals, mode, whenTaking, minutesAtTime, count, drivingExperience, whenStudy, push, preloader, plan
    }
    
    var didFinish: (() -> Void)?
    
    var step = Step.welcome {
        didSet {
            scroll()
            headerUpdate()
        }
    }
    
    lazy var scrollView = makeScrollView()
    lazy var progressView = makeProgressView()
    lazy var previousButton = makePreviousButton()
    lazy var headerLabel = makeHeaderLabel()
    
    private lazy var contentViews: [OSlideView] = {
        [
            OSlideWelcomeView(step: .welcome),
            OSlideLocaleView(step: .locale),
            OSlideExperienceView(step: .experience),
            OSlideGoalsView(step: .goals),
            OSlideModeView(step: .mode),
            OSlideWhenTakingView(step: .whenTaking),
            OSlideMinutesAtTimeView(step: .minutesAtTime),
            OSlideCountView(step: .count),
            OSlideDrivingExperienceView(step: .drivingExperience),
            OWhenStudyView(step: .whenStudy),
            OPushView(step: .push),
            OSlidePreloaderView(step: .preloader),
            OSlidePlanView(step: .plan)
        ]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        headerUpdate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: OSlideViewDelegate
extension OnboardingView: OSlideViewDelegate {
    func slideViewDidNext(from step: Step) {
        OnboardingAnalytics().log(step: step)
        
        let nextRawValue = step.rawValue + 1
        
        guard let nextStep = Step(rawValue: nextRawValue) else {
            didFinish?()
            
            return
        }
        
        self.step = nextStep
    }
}

// MARK: Public
extension OnboardingView {
    func slideViewMoveToPrevious(from step: Step) {
        let previousRawValue = step.rawValue - 1
        
        guard let previousStep = Step(rawValue: previousRawValue) else {
            return
        }
        
        self.step = previousStep
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = Onboarding.background
        
        contentViews
            .enumerated()
            .forEach { [weak self] index, view in
                scrollView.addSubview(view)
                
                view.delegate = self
                
                view.frame.origin = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
            }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(contentViews.count),
                                        height: UIScreen.main.bounds.height)
    }
    
    func scroll() {
        let index = step.rawValue
        
        guard contentViews.indices.contains(index) else {
            return
        }
        
        let view = contentViews[index]
        let frame = contentViews[index].frame
        
        scrollView.scrollRectToVisible(frame, animated: true)
        
        view.moveToThis()
    }
    
    func headerUpdate() {
        switch step {
        case .welcome, .locale, .preloader, .plan, .push:
            previousButton.isHidden = true
            progressView.isHidden = true
        default:
            previousButton.isHidden = false
            progressView.isHidden = false
        }
        
        headerLabel.text = ""
        
        let progressCases: [Step] = [
            .experience, .goals, .mode, .whenTaking, .minutesAtTime, .count, .drivingExperience, .whenStudy
        ]
        guard let index = progressCases.firstIndex(of: step) else {
            return
        }
        progressView.progress = Float(index + 1) / Float(progressCases.count)
        
        headerLabel.attributedText = localizedHeader()
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 75, green: 81, blue: 102))
                            .font(Fonts.SFProRounded.regular(size: 16.scale))
                            .lineHeight(22.4.scale)
                            .textAlignment(.center))
    }
    
    func localizedHeader() -> String {
        switch step {
        case .goals:
            return "Onboarding.Goals.Header".localized
        case .mode:
            return "Onboarding.Mode.Header".localized
        case .whenTaking:
            return "Onboarding.SlideWhenTaking.Header".localized
        case .experience:
            return "Onboarding.Experience.Header".localized
        case .whenStudy:
            return "Onboarding.WhenStudy.Header".localized
        default:
            return ""
        }
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 69.scale : 29.scale),
            previousButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            previousButton.widthAnchor.constraint(equalToConstant: 24.scale),
            previousButton.heightAnchor.constraint(equalToConstant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 16.scale),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            progressView.centerYAnchor.constraint(equalTo: previousButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            headerLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingView {
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
    
    func makePreviousButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Onboarding.Previous"), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.trackTintColor = Onboarding.Progress.track
        view.progressTintColor = Onboarding.Progress.progress
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHeaderLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
