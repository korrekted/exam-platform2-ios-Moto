//
//  OProgressView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

final class OProgressView: UIView {
    private lazy var circleLayer = CAShapeLayer()
    private lazy var progressLayer = CAShapeLayer()
    
    private var isConfigured = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isConfigured else {
            return
        }
        
        createCircularPath()
        
        isConfigured = true
    }
}

// MARK: API
extension OProgressView {
    func progressAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}

// MARK: Private
private extension OProgressView {
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2,
                                                           y: frame.size.height / 2),
                                        radius: ScreenSize.isIphoneXFamily ? 100.scale : 75.scale,
                                        startAngle: -.pi / 2,
                                        endAngle: 3 * .pi / 2,
                                        clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = ScreenSize.isIphoneXFamily ? 19.scale : 15.scale
        circleLayer.strokeColor = Onboarding.Preloader.progressTrack.cgColor
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = ScreenSize.isIphoneXFamily ? 19.scale : 15.scale
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = Onboarding.Preloader.progress.cgColor

        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
}
