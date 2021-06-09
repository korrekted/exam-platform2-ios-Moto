//
//  PaygateIndicatorView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 08.06.2021.
//

import UIKit

final class PaygateIndicatorView: UIView {
    lazy var view1 = makeView()
    lazy var view2 = makeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PaygateIndicatorView {
    func select(isFirst: Bool) {
        view1.backgroundColor = UIColor(integralRed: 31, green: 31, blue: 31).withAlphaComponent(isFirst ? 0.2 : 1)
        view2.backgroundColor = UIColor(integralRed: 31, green: 31, blue: 31).withAlphaComponent(isFirst ? 1 : 0.2)
    }
}

// MARK: Private
private extension PaygateIndicatorView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension PaygateIndicatorView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            view1.widthAnchor.constraint(equalToConstant: 10.scale),
            view1.heightAnchor.constraint(equalToConstant: 10.scale),
            view1.leadingAnchor.constraint(equalTo: leadingAnchor),
            view1.topAnchor.constraint(equalTo: topAnchor),
            view1.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            view2.widthAnchor.constraint(equalToConstant: 10.scale),
            view2.heightAnchor.constraint(equalToConstant: 10.scale),
            view2.trailingAnchor.constraint(equalTo: trailingAnchor),
            view2.topAnchor.constraint(equalTo: topAnchor),
            view2.bottomAnchor.constraint(equalTo: bottomAnchor),
            view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateIndicatorView {
    func makeView() -> CircleView {
        let view = CircleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
