//
//  SCModeView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 15.04.2021.
//

import UIKit

class SCModeView: UIView {
    private lazy var imageView = makeImageView()
    private lazy var label = makeLabel()
    private lazy var iconContainer = makeImageContainer()
    
    private var markLabel: PaddingLabel?
    
    private var labelTopConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension SCModeView {
    func setup(name: String, image: UIImage?, markMessage: String? = nil) {
        label.attributedText = name.attributed(with: .nameAttrs)
        imageView.image = image
        
        if let message = markMessage {
            if markLabel == nil {
                let markLabel = makePaddingLabel(message: message)
                self.markLabel = markLabel
                labelTopConstraint?.constant = 46.scale
                NSLayoutConstraint.activate([
                    markLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
                    markLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale)
                ])
            }
        }
    }
}

// MARK: Private
private extension SCModeView {
    func initialize() {
        
    }
}

// MARK: Make constraints
private extension SCModeView {
    func makeConstraints() {
        labelTopConstraint = label.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        labelTopConstraint?.isActive = true
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            iconContainer.heightAnchor.constraint(equalToConstant: 32.scale),
            iconContainer.widthAnchor.constraint(equalTo: iconContainer.heightAnchor),
            iconContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale),
            iconContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: 12.scale),
            imageView.widthAnchor.constraint(equalToConstant: 24.scale),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SCModeView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7.scale
        view.backgroundColor = StudyPalette.Mode.iconBackground
        view.clipsToBounds = true
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = StudyPalette.Mode.iconTint
        view.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(view)
        return view
    }
    
    func makePaddingLabel(message: String) -> PaddingLabel {
        let view = PaddingLabel()
        view.topInset = 4.scale
        view.bottomInset = 4.scale
        view.textAlignment = .center
        view.layer.cornerRadius = 7.scale
        view.layer.masksToBounds = true
        view.backgroundColor = StudyPalette.Mode.markBackground
        view.font = Fonts.SFProRounded.bold(size: 12.scale)
        view.textColor = StudyPalette.Mode.markText
        view.text = message
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let nameAttrs = TextAttributes()
        .textColor(StudyPalette.Mode.title)
        .font(Fonts.SFProRounded.semiBold(size: 20.scale))
        .lineHeight(28.scale)
}
