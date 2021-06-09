//
//  PaygateOptionView.swift
//  SleepWell
//
//  Created by Andrey Chernyshev on 12/06/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class PaygateOptionView: UIView {
    lazy var saveLabel = makeSaveLabel()
    lazy var checkedImageView = makeCheckedImageView()
    lazy var titleLabel = makeLabel()
    lazy var captionLabel = makeLabel()
    lazy var bottomLabel = makeLabel()
    
    var isSelected = false {
        didSet {
            updateColors()
        }
    }
    
    private(set) var productId: String?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeConstraints()
        updateColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(option: PaygateOption) {
        self.productId = option.productId
        
        updateContent(at: option)
        updateColors()
    }
}

// MARK: Private
private extension PaygateOptionView {
    func updateContent(at option: PaygateOption) {
        titleLabel.attributedText = option.title
        captionLabel.attributedText = option.caption
        
        saveLabel.attributedText = option.save
        saveLabel.isHidden = option.save == nil
        
        bottomLabel.attributedText = option.bottomLine
    }

    func updateColors() {
        backgroundColor = isSelected ? UIColor(integralRed: 255, green: 101, blue: 1) : UIColor(integralRed: 220, green: 220, blue: 220)
        
        checkedImageView.isHidden = !isSelected
        
        titleLabel.textColor = isSelected ? PaygatePalette.Option.selectedText : PaygatePalette.Option.deselectText
        captionLabel.textColor = isSelected ? PaygatePalette.Option.selectedText : PaygatePalette.Option.deselectText
        bottomLabel.textColor = isSelected ? PaygatePalette.Option.selectedText : PaygatePalette.Option.deselectText
        
        saveLabel.textColor = isSelected ? PaygatePalette.Option.saveSelectedText : PaygatePalette.Option.saveDeselectedText
        saveLabel.backgroundColor = isSelected ? PaygatePalette.Option.saveSelectedBackground : PaygatePalette.Option.saveDeselectedBackground
    }
}

// MARK: Make constraints
private extension PaygateOptionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            saveLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveLabel.centerYAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkedImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            checkedImageView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedImageView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            captionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 38.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomLabel.topAnchor.constraint(equalTo: topAnchor, constant: 75.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateOptionView {
    func makeCheckedImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.Paid.Checked")
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
    
    func makeSaveLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.bottomInset = 1.scale
        view.topInset = 1.scale
        view.leftInset = 7.scale
        view.rightInset = 7.scale
        view.textAlignment = .center
        view.layer.cornerRadius = 4.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
