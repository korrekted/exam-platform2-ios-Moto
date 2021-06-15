//
//  FlashcardsTableCell.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import UIKit
import Kingfisher

final class FlashcardsTopicsTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var pictureView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var countLabel = makeLabel()
    lazy var progressView = makeProgressView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension FlashcardsTopicsTableCell {
    func setup(flashcard: FlashcardTopic) {
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
        
        if let imageUrl = URL(string: flashcard.imageUrl) {
            pictureView.kf.setImage(with: imageUrl)
        }
        
        nameLabel.attributedText = flashcard.name
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
                            .font(Fonts.SFProRounded.bold(size: 18.scale))
                            .lineHeight(25.2.scale))
        
        countLabel.attributedText = String(format: "Flashcards.Count".localized, flashcard.count)
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 68, green: 68, blue: 68))
                            .font(Fonts.SFProRounded.regular(size: 16.scale))
                            .lineHeight(22.4.scale))
        
        progressView.progress = Float(flashcard.progress) / Float(flashcard.count)
    }
}

// MARK: Private
private extension FlashcardsTopicsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension FlashcardsTopicsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 261.scale)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            pictureView.topAnchor.constraint(equalTo: container.topAnchor),
            pictureView.heightAnchor.constraint(equalToConstant: 163.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 10.scale),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale),
        ])
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            countLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.scale),
            countLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale),
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.scale),
            progressView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale),
            progressView.heightAnchor.constraint(equalToConstant: 7.scale),
            progressView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FlashcardsTopicsTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 3.scale
        view.layer.masksToBounds = true
        view.progressTintColor = UIColor(integralRed: 255, green: 101, blue: 1)
        view.trackTintColor = UIColor(integralRed: 237, green: 237, blue: 237)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
