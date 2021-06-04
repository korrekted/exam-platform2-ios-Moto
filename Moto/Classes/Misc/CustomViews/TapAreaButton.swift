//
//  TapAreaButton.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 23.02.2021.
//

import UIKit

final class TapAreaButton: UIButton {
    var dx: CGFloat = -10.scale
    var dy: CGFloat = -10.scale
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: dx, dy: dy).contains(point)
    }
}
