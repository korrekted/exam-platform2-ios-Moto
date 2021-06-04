//
//  UIEdgeInsets+Extension.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 28.02.2021.
//

import Foundation

extension UIEdgeInsets {
    func inverted() -> UIEdgeInsets {
        UIEdgeInsets(
            top: -top,
            left: -left,
            bottom: -bottom,
            right: -right
        )
    }
}
