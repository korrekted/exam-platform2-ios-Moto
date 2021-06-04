//
//  PaygateView.swift
//  SleepWell
//
//  Created by Andrey Chernyshev on 12/06/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class PaygateView: UIView {
    lazy var mainView = makeMainView()
    lazy var specialOfferView = makeSpecialOfferView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            specialOfferView.leadingAnchor.constraint(equalTo: leadingAnchor),
            specialOfferView.trailingAnchor.constraint(equalTo: trailingAnchor),
            specialOfferView.topAnchor.constraint(equalTo: topAnchor),
            specialOfferView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension PaygateView {
    func makeMainView() -> PaygateMainView {
        let view = PaygateMainView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSpecialOfferView() -> PaygateSpecialOfferView {
        let view = PaygateSpecialOfferView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
