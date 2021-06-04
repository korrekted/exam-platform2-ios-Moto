//
//  MainProgressView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 27.01.2020.
//

import UIKit

class MainProgressView: UIView {
    private let trackBorderWidth: CGFloat = 11.scale
    private let startDegrees: CGFloat = 180
    private let endDegrees: CGFloat = 0
    
    private var bigProgress = 0
    private var mediumProgress = 0
    private var smallProgress = 0
    
    override func draw(_ rect: CGRect) {
        drawProgress(for: bigProgress, multiplerSize: 1, color: StatsPalette.Progress.testTaken)
        drawProgress(for: mediumProgress, multiplerSize: 0.8, color: StatsPalette.Progress.correctAnswers)
        drawProgress(for: smallProgress, multiplerSize: 0.6, color: StatsPalette.Progress.questionsTaken)
    }
}

// MARK: Public
extension MainProgressView {
    func setProgress(big: Int, medium: Int, small: Int) {
        bigProgress = big
        mediumProgress = medium
        smallProgress = small
        setNeedsDisplay()
    }
}

// MARK: Private
private extension MainProgressView {
    func drawProgress(for percent: Int, multiplerSize: CGFloat, color: UIColor) {
        let startWithMultipler = startDegrees + 15 / multiplerSize
        let endWithMultipler = endDegrees - 15 / multiplerSize
        let startAngle: CGFloat = radians(of: startWithMultipler)
        let endAngle: CGFloat = radians(of: endWithMultipler)
        let progressAngle = radians(of: startWithMultipler + (360 - startWithMultipler + endWithMultipler) * CGFloat(max(0.0, min(Double(percent) / 100, 1.0))))

        let radius = (min(bounds.midX, bounds.maxY) - trackBorderWidth / 2) * multiplerSize
        let center = CGPoint(x: bounds.midX, y: bounds.maxY)
        
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: progressAngle, clockwise: true)
        trackPath.lineWidth = trackBorderWidth
        trackPath.lineCapStyle = .round
        progressPath.lineWidth = trackBorderWidth
        progressPath.lineCapStyle = .round

        color.withAlphaComponent(0.3).set()
        trackPath.stroke()

        color.set()
        progressPath.stroke()
        
    }
    
    func radians(of degrees: CGFloat) -> CGFloat {
        return degrees / 180 * .pi
    }
}
