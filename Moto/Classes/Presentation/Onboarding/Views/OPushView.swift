//
//  OPushView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 29.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class OPushView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subtitleLabel = makeSubtitleLabel()
    lazy var imageView = makeImageView()
    lazy var allowButton = makeAllowButton()
    lazy var notNowButton = makeNotNowButton()
    
    private lazy var sendToken = PublishRelay<String>()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        SDKStorage.shared
            .pushNotificationsManager
            .add(observer: self)
    }
}

// MARK:
extension OPushView: PushNotificationsManagerDelegate {
    func pushNotificationsManagerDidReceive(token: String?) {
        SDKStorage.shared
            .pushNotificationsManager
            .remove(observer: self)
        
        guard let token = token else {
            onNext()
            return
        }
        
        sendToken.accept(token)
    }
}

// MARK: Private
private extension OPushView {
    func initialize() {
        allowButton.rx.tap
            .subscribe(onNext: {
                SDKStorage.shared
                    .pushNotificationsManager
                    .requestAuthorization()
            })
            .disposed(by: disposeBag)
        
        sendToken
            .subscribe(onNext: { [weak self] token in
                guard let self = self else {
                    return
                }
                
                self.scope.notificationKey = token
                
                self.onNext()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension OPushView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            subtitleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 320.scale : 280.scale),
            imageView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 322.scale : 282.scale),
            imageView.bottomAnchor.constraint(equalTo: allowButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -56.scale : -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            allowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            allowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            allowButton.heightAnchor.constraint(equalToConstant: 60.scale),
            allowButton.bottomAnchor.constraint(equalTo: notNowButton.topAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            notNowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            notNowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            notNowButton.heightAnchor.constraint(equalToConstant: 28.scale),
            notNowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OPushView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.semiBold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Push.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.secondaryText)
            .font(Fonts.SFProRounded.regular(size: 20.scale))
            .lineHeight(28.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Push.Subtitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Push.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAllowButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryButtonTint)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Onboarding.primaryButton
        view.layer.cornerRadius = 20.scale
        view.setAttributedTitle("Onboarding.Push.Allow".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNotNowButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 75, green: 81, blue: 102))
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.setAttributedTitle("Onboarding.Push.NotNow".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
