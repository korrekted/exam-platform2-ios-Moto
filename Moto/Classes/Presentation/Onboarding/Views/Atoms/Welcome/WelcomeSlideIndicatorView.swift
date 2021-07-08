//
//  WelcomeSlideIndicatorView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 20.06.2021.
//

import UIKit

final class WelcomeSlideIndicatorView: UIView {
    lazy var index = 1 {
        didSet {
            update()
        }
    }
    
    lazy var indicator1View = makeIndicatorView()
    lazy var indicator2View = makeIndicatorView()
    lazy var indicator3View = makeIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        update()
    }
}

// MARK: Private
private extension WelcomeSlideIndicatorView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        indicator1View.backgroundColor = UIColor(integralRed: 31, green: 31, blue: 31, alpha: index == 1 ? 1 : 0.2)
        indicator2View.backgroundColor = UIColor(integralRed: 31, green: 31, blue: 31, alpha: index == 2 ? 1 : 0.2)
        indicator3View.backgroundColor = UIColor(integralRed: 31, green: 31, blue: 31, alpha: index == 3 ? 1 : 0.2)
        
        indicator1View.frame.size = CGSize(width: index == 1 ? 55.scale : 8.scale, height: 8.scale)
        indicator2View.frame.size = CGSize(width: index == 2 ? 55.scale : 8.scale, height: 8.scale)
        indicator3View.frame.size = CGSize(width: index == 3 ? 55.scale : 8.scale, height: 8.scale)
        
        switch index {
        case 1:
            indicator1View.frame.origin = CGPoint(x: 147.scale, y: 0)
            indicator2View.frame.origin = CGPoint(x: 207.scale, y: 0)
            indicator3View.frame.origin = CGPoint(x: 220.scale, y: 0)
        case 2:
            indicator1View.frame.origin = CGPoint(x: 147.scale, y: 0)
            indicator2View.frame.origin = CGPoint(x: 160.scale, y: 0)
            indicator3View.frame.origin = CGPoint(x: 220.scale, y: 0)
        case 3:
            indicator1View.frame.origin = CGPoint(x: 147.scale, y: 0)
            indicator2View.frame.origin = CGPoint(x: 160.scale, y: 0)
            indicator3View.frame.origin = CGPoint(x: 173.scale, y: 0)
        default:
            break
        }
    }
}

// MARK: Lazy initialization
private extension WelcomeSlideIndicatorView {
    func makeIndicatorView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 4.scale
        addSubview(view)
        return view
    }
}
