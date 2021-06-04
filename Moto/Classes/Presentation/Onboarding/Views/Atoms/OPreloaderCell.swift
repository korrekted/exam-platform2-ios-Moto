//
//  OPreloaderCell.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit

final class OPreloaderCell: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    var isChecked: Bool = false {
        didSet {
            imageView.image = UIImage(named: isChecked ? "Onboarding.PreloaderCell.Checked" : "Onboarding.PreloaderCell.Unchecked")
        }
    }
    
    var title: String = "" {
        didSet {
            let attrs = TextAttributes()
                .font(Fonts.SFProRounded.semiBold(size: 20.scale))
                .lineHeight(28.scale)
                .textColor(Onboarding.Preloader.text)
            
            label.attributedText = title.attributed(with: attrs)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OPreloaderCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24.scale),
            imageView.heightAnchor.constraint(equalToConstant: 24.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OPreloaderCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Onboarding.PreloaderCell")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
