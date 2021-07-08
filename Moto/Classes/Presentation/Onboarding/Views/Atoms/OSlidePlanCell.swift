//
//  OSlide15Cell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

final class OSlidePlanCell: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subtitleLabel = makeSubtitleLabel()
    
    var title: String = "" {
        didSet {
            let attrs = TextAttributes()
                .font(Fonts.SFProRounded.semiBold(size: 16.scale))
                .lineHeight(22.scale)
                .textColor(UIColor(integralRed: 205, green: 101, blue: 1))
            titleLabel.attributedText = title.attributed(with: attrs)
        }
    }
    
    var subtitle: String = "" {
        didSet {
            let attrs = TextAttributes()
                .font(Fonts.SFProRounded.semiBold(size: 16.scale))
                .lineHeight(22.scale)
                .textColor(UIColor(integralRed: 75, green: 81, blue: 102))
            subtitleLabel.attributedText = subtitle.attributed(with: attrs)
        }
    }
    
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
private extension OSlidePlanCell {
    func initialize() {
        backgroundColor = UIColor(integralRed: 253, green: 246, blue: 241)
        
        layer.cornerRadius = 20.scale
    }
}

// MARK: Make constraints
private extension OSlidePlanCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 46.scale),
            imageView.heightAnchor.constraint(equalToConstant: 34.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 74.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 74.scale),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3.scale),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlidePlanCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
