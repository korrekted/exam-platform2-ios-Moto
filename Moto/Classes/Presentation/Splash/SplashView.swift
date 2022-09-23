//
//  SplashView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class SplashView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var preloaderView = makePreloader()
    lazy var preloaderLabel = makePreloaderLabel()
    lazy var imageView = makeImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SplashView {
    func initialize() {
        backgroundColor = SplashPalette.background
    }
}

// MARK: Make constraints
private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 104.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloaderView.widthAnchor.constraint(equalToConstant: 32.scale),
            preloaderView.heightAnchor.constraint(equalToConstant: 32.scale),
            preloaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloaderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 32.scale : 22.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloaderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloaderLabel.topAnchor.constraint(equalTo: preloaderView.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 445.scale : 350.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeTitleLabel() -> UILabel {
        let attrs1 = TextAttributes()
            .textColor(SplashPalette.primaryText)
            .font(Fonts.SFProRounded.bold(size: 36.scale))
            .lineHeight(43.2.scale)
            .textAlignment(.center)
        
        let attrs2 = TextAttributes()
            .textColor(SplashPalette.secondaryText)
            .font(Fonts.SFProRounded.bold(size: 36.scale))
            .lineHeight(43.2.scale)
            .textAlignment(.center)
        
        let string = NSMutableAttributedString()
        string.append("Splash.Title.Part1".localized.attributed(with: attrs1))
        string.append("Splash.Title.Part2".localized.attributed(with: attrs2))
        string.append("Splash.Title.Part3".localized.attributed(with: attrs1))
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = string
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 32.scale, height: 32.scale), color: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloaderLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Splash.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
