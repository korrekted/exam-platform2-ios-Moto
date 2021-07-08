//
//  OSlide4Cell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OGoalCell: PaddingLabel {
    var isSelected = false {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OGoalCell {
    func initialize() {
        backgroundColor = Onboarding.Goal.background
        
        layer.masksToBounds = true
        layer.cornerRadius = 20.scale
        
        topInset = 16.scale
        bottomInset = 16.scale
        leftInset = 24.scale
        rightInset = 24.scale
        
        font = Fonts.SFProRounded.regular(size: 20.scale)
    }
    
    func update() {
        backgroundColor = isSelected ? Onboarding.Goal.selectedBackground : Onboarding.Goal.background
        textColor = isSelected ? Onboarding.Goal.selectedText : Onboarding.Goal.text
    }
}
