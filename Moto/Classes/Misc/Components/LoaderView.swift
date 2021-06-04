//
//  LoaderView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 25.05.2021.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class LoaderView: UIView {
    private lazy var loader = makeImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Public
extension LoaderView {
    var isLoading: Binder<Bool> {
        Binder(loader) { base, isLoading in
            base.isHidden = !isLoading
            if isLoading {
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.byValue = CGFloat(.pi * 2.0)
                animation.duration = 1
                animation.repeatCount = .infinity
                base.layer.add(animation, forKey: "rotate")
            } else {
                base.layer.removeAllAnimations()
            }
        }
    }
}

// MARK: Private
private extension LoaderView {
    func initialize() {
        backgroundColor = .clear
        loader.backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension LoaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            loader.topAnchor.constraint(equalTo: topAnchor),
            loader.bottomAnchor.constraint(equalTo: bottomAnchor),
            loader.leftAnchor.constraint(equalTo: leftAnchor),
            loader.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LoaderView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "General.Loader")
        view.tintColor = TestStatsPalette.loader
        addSubview(view)
        return view
    }
}
