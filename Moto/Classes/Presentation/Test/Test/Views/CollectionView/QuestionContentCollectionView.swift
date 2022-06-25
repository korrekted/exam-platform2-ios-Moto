//
//  QuestionContentCollectionView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 10.02.2021.
//

import UIKit
import RxCocoa

final class QuestionContentCollectionView: UICollectionView {
    var expandContent: ((QuestionContentCollectionType) -> Void)?
    
    private lazy var elements = [QuestionContentCollectionType]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(elements: [QuestionContentCollectionType]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension QuestionContentCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: QuestionContentCollectionCell.self), for: indexPath) as! QuestionContentCollectionCell
        cell.setup(content: element) { [weak self] in
            self?.expandContent?(element)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension QuestionContentCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            assertionFailure("Wrong layout type supplied")
            return .zero
        }
        
        let cellWidth = collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let cellHeight = collectionView.frame.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom

        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: Private
private extension QuestionContentCollectionView {
    func initialize() {
        register(QuestionContentCollectionCell.self, forCellWithReuseIdentifier: String(describing: QuestionContentCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
