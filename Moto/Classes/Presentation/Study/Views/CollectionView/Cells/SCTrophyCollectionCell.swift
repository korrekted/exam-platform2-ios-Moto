//
//  SCTrophyCollectionCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 13.04.2021.
//

import UIKit

class SCTrophyCollectionCell: UICollectionViewCell {
    
    lazy var trophyView = makeTrophyView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension SCTrophyCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            trophyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trophyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            trophyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            trophyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale),
        ])
    }
}

// MARK: Lazy initialization
private extension SCTrophyCollectionCell {
    func makeTrophyView() -> TrophyView {
        let view = TrophyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
