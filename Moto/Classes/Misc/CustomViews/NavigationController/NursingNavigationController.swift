//
//  NursingNavigationController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

class NursingNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apply(settings: .default())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
}

// MARK: API
extension NursingNavigationController {
    func apply(settings: NursingNavigationControllerSettings) {
        navigationBar.setBackgroundImage(settings.backgroundImage, for: .default)
        navigationBar.shadowImage = settings.shadowImage
        navigationBar.isTranslucent = settings.isTranslucent
        navigationBar.tintColor = settings.tintColor
        navigationBar.titleTextAttributes = settings.titleTextAttrributes
        navigationBar.isHidden = true
    }
}
