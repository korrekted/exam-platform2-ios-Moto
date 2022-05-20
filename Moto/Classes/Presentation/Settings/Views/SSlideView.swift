//
//  SSlideView.swift
//  Moto
//
//  Created by Андрей Чернышев on 20.05.2022.
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
