//
//  PaygateMainInfoCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 25.11.2020.
//

import UIKit

final class PaygateMainInfoCell: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    var title: String = "" {
        didSet {
            label.attributedText = title
                .attributed(with: TextAttributes()
                                .textColor(PaygatePalette.secondaryText)
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
private extension PaygateMainInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 41.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 13.scale),
            imageView.heightAnchor.constraint(equalToConstant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateMainInfoCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Paygate.Main.CellChecked")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
