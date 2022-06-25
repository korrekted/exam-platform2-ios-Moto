//
//  TestStatsProgressView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

final class TestStatsProgressView: UIView {
    private lazy var circleLayer = CAShapeLayer()
    private lazy var progressLayer = CAShapeLayer()
    private lazy var passingScoreLayer = CAShapeLayer()
    
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

// MARK: Public
extension TestStatsProgressView {
    func progress(progress: CGFloat, passingScore: CGFloat) {
        progressLayer.strokeEnd = progress
        passingScoreLayer.transform = CATransform3DMakeRotation(.pi * 2 * passingScore, 0, 0, 1)
    }
}

// MARK: Private
private extension TestStatsProgressView {
    func createCircularPath() {
        let circleCenter = CGPoint(x: bounds.midX, y:bounds.midY)
        let circleRadius = bounds.size.width / 2
        let circularPath1 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: -circleRadius, y: -circleRadius), size: bounds.size), cornerRadius: circleRadius)
        
        circleLayer.path = circularPath1.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 15.scale
        circleLayer.strokeColor = TestStatsPalette.incorrect.cgColor
        circleLayer.position = circleCenter
        
        progressLayer.path = circularPath1.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 15.scale
        progressLayer.strokeColor = TestStatsPalette.correct.cgColor
        progressLayer.position = circleCenter
        progressLayer.lineCap = .round
        
        passingScoreLayer.path = UIBezierPath(roundedRect: CGRect(x: -5.scale, y: -circleRadius - 5.scale, width: 2 * 5.scale, height: 2 * 5.scale), cornerRadius: 5.scale).cgPath
        passingScoreLayer.backgroundColor = TestStatsPalette.passingScore.cgColor
        passingScoreLayer.position = circleCenter

        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
        layer.addSublayer(passingScoreLayer)
    }
}
