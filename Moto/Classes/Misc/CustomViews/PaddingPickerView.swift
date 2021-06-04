//
//  PaddingPickerView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 28.02.2021.
//

import Foundation

class PaddingPickerView: UIPickerView {
    var padding: UIEdgeInsets?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let insets = padding else {
            return super.hitTest(point, with: event)
        }
        
        let newPoint = bounds.inset(by: insets.inverted()).contains(point) ? CGPoint(x: bounds.midX, y: point.y) : point
        
        return super.hitTest(newPoint, with: event)
    }
}
