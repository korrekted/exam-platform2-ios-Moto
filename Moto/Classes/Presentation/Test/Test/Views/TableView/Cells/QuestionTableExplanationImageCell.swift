//
//  QuestionTableExplanationImageCell.swift
//  CDL
//
//  Created by Андрей Чернышев on 21.06.2022.
//

import UIKit
import Kingfisher

final class QuestionTableExplanationImageCell: UITableViewCell {
    lazy var explanationImage = makeImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        explanationImage.kf.cancelDownloadTask()
        explanationImage.image = nil
    }
}

// MARK: Public
extension QuestionTableExplanationImageCell {
    func confugure(image: URL) {
        explanationImage.kf.setImage(with: image)
    }
}

// MARK: Private
private extension QuestionTableExplanationImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension QuestionTableExplanationImageCell {
    func makeConstraints() {
        let bottomConstraint = explanationImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = .init(rawValue: 999)
        NSLayoutConstraint.activate([
            explanationImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            bottomConstraint,
            explanationImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            explanationImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            explanationImage.heightAnchor.constraint(equalTo: explanationImage.widthAnchor, multiplier: 0.39)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionTableExplanationImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 20.scale
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
