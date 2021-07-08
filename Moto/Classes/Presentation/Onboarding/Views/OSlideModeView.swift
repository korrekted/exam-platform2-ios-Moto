//
//  OSlideModeView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 20.06.2021.
//

import UIKit
import RxSwift

final class OSlideModeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subtitleLabel = makeSubtitleLabel()
    lazy var modesView = makeModesView()
    lazy var button = makeButton()
    
    private lazy var manager = ProfileManagerCore()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideModeView {
    func initialize() {
        button.rx.tap
            .flatMapLatest { [weak self] _ -> Single<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                guard let selected = self.modesView
                        .elements
                        .first(where: { $0.isSelected })
                else {
                    return .never()
                }
                
                return self.manager
                    .set(testMode: selected.code)
                    .map { true }
                    .catchAndReturn(false)
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] success in
                guard success else {
                    Toast.notify(with: "Onboarding.FailedToSave".localized, style: .danger)
                    return
                }
                
                self?.onNext()
            })
            .disposed(by: disposeBag)
        
        modesView.setup(elements: [
            .init(title: "Onboarding.Mode.Cell1.Title".localized,
                  subtitle: "Onboarding.Mode.Cell1.Subtitle".localized,
                  image: "Onboarding.Mode.NoExplanations",
                  code: 2,
                  isSelected: true),
            
            .init(title: "Onboarding.Mode.Cell2.Title".localized,
                  subtitle: "Onboarding.Mode.Cell2.Subtitle".localized,
                  image: "Onboarding.Mode.FullComplect",
                  code: 0,
                  isSelected: false),
            
            .init(title: "Onboarding.Mode.Cell3.Title".localized,
                  subtitle: "Onboarding.Mode.Cell3.Subtitle".localized,
                  image: "Onboarding.Mode.OnAnExam",
                  code: 1,
                  isSelected: false)
        ], isNeedScroll: false)
    }
}

// MARK: Make constraints
private extension OSlideModeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            subtitleLabel.bottomAnchor.constraint(equalTo: modesView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            modesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            modesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            modesView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale),
            modesView.heightAnchor.constraint(equalToConstant: 195.scale)
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
private extension OSlideModeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.semiBold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Mode.Title".localized.attributed(with: attrs)
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
        view.attributedText = "Onboarding.Mode.Subtitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeModesView() -> OModesCollectionView {
        let layout = OModesCollectionLayout()
        layout.itemSize = CGSize(width: 316.scale, height: .zero)
        
        let view = OModesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
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
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
