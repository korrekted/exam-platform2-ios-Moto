//
//  QuestionContentCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 04.02.2021.
//

import UIKit

final class QuestionTableContentCell: UITableViewCell {
    lazy var collectionView = makeCollectionView()

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
extension QuestionTableContentCell {
    func configure(content: [QuestionContentCollectionType], didTapExpand: @escaping (QuestionContentCollectionType) -> Void) {
        collectionView.setup(elements: content)
        collectionView.expandContent = didTapExpand
    }
}

// MARK: Private
private extension QuestionTableContentCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension QuestionTableContentCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.scale),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionTableContentCell {
    func makeCollectionView() -> QuestionContentCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15.scale
        layout.minimumInteritemSpacing = 0.scale
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20.scale, bottom: 0, right: 20.scale)
        
        let view = QuestionContentCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
