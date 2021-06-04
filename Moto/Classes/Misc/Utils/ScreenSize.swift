//
//  ScreenSize.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

enum ScreenSize {
    static let bounds: CGRect = (UIScreen.main.bounds)
    static let width: CGFloat = (bounds.width)
    static let height: CGFloat = (bounds.height)
    static let maxLength: CGFloat = (max(width, height))
    static let minLength: CGFloat = (min(width, height))
    
    static let isIphone = (UI_USER_INTERFACE_IDIOM() == .phone)
    static let isRetina = (UIScreen.main.scale >= 2.0)
    static let isIphone6 = (isIphone && maxLength == 667.0)
    static let isIphone6Plus = (isIphone && maxLength == 736.0)
    static let isIphoneX = (isIphone && maxLength == 812.0)
    static let isIphoneXMax = (isIphone && maxLength == 896.0)
    static let isIphoneXFamily = (isIphone && maxLength / minLength > 2.0)
    
    static let statusBarSize = UIApplication.shared.statusBarFrame.size
    static let statusBarHeight = statusBarSize.height
}
