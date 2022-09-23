//
//  Spinner.swift
//  DMV
//
//  Created by Андрей Чернышев on 19.05.2022.
//

import UIKit

final class Spinner: UIView {
    enum Color {
        case blue, white
    }
    
    private let rotationKey = "spinner_rotation_key"
    private let scaleKey = "spinner_scale_key"
    
    private lazy var isAnimating = false
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame.size = size
        view.image = UIImage(named: imageName())
        view.contentMode = .scaleAspectFit
        addSubview(view)
        return view
    }()
    
    private let size: CGSize
    private let color: Color
    
    init(size: CGSize, color: Color = .blue) {
        self.size = size
        self.color = color
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        size
    }
}

// MARK: Public
extension Spinner {
    func startAnimating() {
        isHidden = false
        isAnimating = true
        
        startRotation()
        startResize()
    }
    
    func stopAnimating() {
        isHidden = true
        isAnimating = false
        
        imageView.layer.removeAnimation(forKey: rotationKey)
        imageView.layer.removeAnimation(forKey: scaleKey)
    }
}

// MARK: Private
private extension Spinner {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func startRotation() {
        guard imageView.layer.animation(forKey: rotationKey) == nil else {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = Float.pi * 2
        animation.fromValue = 0
        animation.isCumulative = true
        animation.repeatCount = HUGE
        animation.duration = 2.5
        
        imageView.layer.add(animation, forKey: rotationKey)
    }
    
    func startResize() {
        guard imageView.layer.animation(forKey: scaleKey) == nil else {
            return
        }

        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.1
        animation.fromValue = 1
        animation.isCumulative = false
        animation.autoreverses = true
        animation.repeatCount = HUGE
        animation.duration = 2.5

        imageView.layer.add(animation, forKey: scaleKey)
    }
    
    func imageName() -> String {
        switch color {
        case .blue:
            return "Spinner.Black"
        case .white:
            return "Spinner.White"
        }
    }
}
