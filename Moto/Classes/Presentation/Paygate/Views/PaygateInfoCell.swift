//
//  PaygateMainInfoCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 25.11.2020.
//

import UIKit

final class PaygateInfoCell: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    var title: String = "" {
        didSet {
            label.attributedText = title
                .attributed(with: TextAttributes()
                                .textColor(UIColor(integralRed: 68, green: 68, blue: 68))
                                .font(Fonts.SFProRounded.regular(size: 16.scale))
                                .lineHeight(22.scale))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension PaygateInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            imageView.widthAnchor.constraint(equalToConstant: 13.scale),
            imageView.heightAnchor.constraint(equalToConstant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 41.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateInfoCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Paygate.CellChecked")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
