//
//  CountCircleView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 28.06.2021.
//

import UIKit
import CoreGraphics

final class CountCircleView: UIView {
    // 1 - 7
    lazy var value = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    lazy var pieBackgroundColor = UIColor(integralRed: 49, green: 115, blue: 180) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    lazy var pieFilledColor = UIColor(integralRed: 169, green: 40, blue: 100) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private lazy var angleOffset = CGFloat(-90)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
    
        pieBackgroundColor.set()
        context.fillEllipse(in: rect)
        
        let progress = transformProgress()
    
        let prgs = CGFloat(fmax(0.0, fmin(1.0, progress / 10)))
    
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = center.y
        let angle = deg2rad(360.0 * prgs + angleOffset)
        let points = [
            CGPoint(x: center.x, y: 0.0),
            center,
            CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
        ]
    
        pieFilledColor.set()
        if prgs > 0.0 {
            context.addLines(between: points)
            context.addArc(center: center,
                           radius: radius,
                           startAngle: deg2rad(angleOffset),
                           endAngle: angle,
                           clockwise: false)
            context.drawPath(using: .eoFill)
        }
    }
}

// MARK: Private
private extension CountCircleView {
    // 1 - 10
    // return lose
    func transformProgress() -> Double {
        return Double(value) + 3
    }
    
    func deg2rad(_ double: Double) -> Double {
        return double * .pi / 180
    }

    func deg2rad(_ cgFloat: CGFloat) -> CGFloat {
        return cgFloat * .pi / 180
    }
}
