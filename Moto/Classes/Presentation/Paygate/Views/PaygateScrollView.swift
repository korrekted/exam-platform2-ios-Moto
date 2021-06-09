//
//  PaygateScrollView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 08.06.2021.
//

import UIKit

final class PaygateScrollView: UIScrollView {
    lazy var paidView = PaygatePaidView()
    lazy var freeView = PaygateFreeView()
    
    private var paygate: Paygate?
    private var config: PaygateViewModel.Config?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        construct()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        construct()
        fill()
    }
}

// MARK: Public
extension PaygateScrollView {
    func setup(paygate: Paygate) {
        self.paygate = paygate
        
        fill()
    }
    
    func setup(config: PaygateViewModel.Config) {
        self.config = config
        
        construct()
    }
}

// MARK: Private
private extension PaygateScrollView {
    func fill() {
        guard let options = paygate?.options else {
            return
        }
        
        paidView.setup(options: options)
    }
    
    func construct() {
        guard let config = self.config else {
            return
        }
        
        switch config {
        case .block:
            asBlock()
        case .suggest:
            asSuggest()
        }
    }
    
    func asBlock() {
        paidView.frame.size = CGSize(width: 327.scale, height: ScreenSize.isIphoneXFamily ? 549.scale : 500.scale)
        paidView.frame.origin = CGPoint(x: 24.scale, y: 0)
        addSubview(paidView)
        
        contentSize = CGSize(width: 375.scale, height: frame.size.height)
    }
    
    func asSuggest() {
        paidView.frame.size = CGSize(width: 314.scale, height: ScreenSize.isIphoneXFamily ? 549.scale : 500.scale)
        paidView.frame.origin = CGPoint(x: 24.scale, y: 0)
        addSubview(paidView)
        
        freeView.frame.size = CGSize(width: 308.scale, height: 369.scale)
        freeView.frame.origin = CGPoint(x: 354.scale, y: ScreenSize.isIphoneXFamily ? 90.scale : 60.scale)
        addSubview(freeView)
        
        contentSize = CGSize(width: 686.scale, height: frame.size.height)
    }
}
