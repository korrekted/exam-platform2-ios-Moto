//
//  SSlideView.swift
//  DMV
//
//  Created by Андрей Чернышев on 19.05.2022.
//

import UIKit

class SSlideView: UIView {
    weak var vc: UIViewController?
    
    var didNextTapped: (() -> Void)?
    
    func moveToThis() {}
    
    @objc
    func onNext() {
        didNextTapped?()
    }
}
