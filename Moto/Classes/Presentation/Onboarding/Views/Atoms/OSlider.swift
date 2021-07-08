//
//  OSlideView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit

final class OSlider: UISlider {
    lazy var trackHeight = 16.scale
    lazy var touchAreaInsetX = CGFloat(0)
    lazy var touchAreaInsetY = CGFloat(0)
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: touchAreaInsetX, dy: touchAreaInsetX).contains(point)
    }
}
