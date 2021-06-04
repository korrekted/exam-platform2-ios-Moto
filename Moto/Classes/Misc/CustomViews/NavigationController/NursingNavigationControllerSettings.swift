//
//  NursingNavigationControllerSettings.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct NursingNavigationControllerSettings {
    let backgroundImage: UIImage
    let shadowImage: UIImage
    let isTranslucent: Bool
    let tintColor: UIColor
    let titleTextAttrributes: [NSAttributedString.Key: Any]
}

// MARK: Make
extension NursingNavigationControllerSettings {
    static func `default`() -> NursingNavigationControllerSettings {
        NursingNavigationControllerSettings(backgroundImage: UIImage(),
                                            shadowImage: UIImage(),
                                            isTranslucent: true,
                                            tintColor: NavigationPalette.tabBarBackground,
                                            titleTextAttrributes: TextAttributes()
                                                .textColor(UIColor.white)
                                                .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                                                .textAlignment(.center)
                                                .dictionary)
    }
}
