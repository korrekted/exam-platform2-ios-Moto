//
//  QuestionContentCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 04.02.2021.
//

import Foundation

class QuestionContentCell: UITableViewCell {
    
    private lazy var collectionView = makeCollectionView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension QuestionContentCell {
    func configure(content: [QuestionContentType]) {
        collectionView.setup(elements: content)
    }
}

// MARK: Private
private extension QuestionContentCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension QuestionContentCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.scale),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionContentCell {
    func makeCollectionView() -> QuestionContentCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15.scale
        layout.minimumInteritemSpacing = 0.scale
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        let view = QuestionContentCollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
