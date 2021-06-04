//
//  ProgressView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 31.03.2021.
//

import UIKit

class ProgressView: UIView {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var percentLabel = makePercentLabel()
    private lazy var progressView = makeProgress()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: API
extension ProgressView {
    func setTitle(title: String) {
        titleLabel.attributedText = title.attributed(with: .attr)
    }
    
    func setProgress(percent: Int) {
        percentLabel.attributedText = "\(percent)%".attributed(with: .attr)
        progressView.setProgress(min(Float(Double(percent) / 100), 1.0), animated: false)
    }
}


// MARK: Private
private extension ProgressView {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension ProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale),
            titleLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.topAnchor.constraint(equalTo: topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale),
            percentLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProgressView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(view)
        return view
    }
    
    func makeProgress() -> UIProgressView {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.trackTintColor = NavigationPalette.navigationTrackTint
        view.progressTintColor = NavigationPalette.navigationProgressTint
        view.subviews.forEach {
            $0.layer.cornerRadius = 7.scale
            $0.clipsToBounds = true
        }
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let attr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textColor(NavigationPalette.navigationTint)
}
