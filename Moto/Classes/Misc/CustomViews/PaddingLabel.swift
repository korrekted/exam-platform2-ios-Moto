//
//  PaddingLabel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

class PaddingLabel: UILabel {
    var topInset: CGFloat = 5.0.scale
    var bottomInset: CGFloat = 5.0.scale
    var leftInset: CGFloat = 7.0.scale
    var rightInset: CGFloat = 7.0.scale

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
