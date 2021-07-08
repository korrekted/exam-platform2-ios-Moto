//
//  OModesCollectionLayout.swift
//  CDL
//
//  Created by Andrey Chernyshev on 21.06.2021.
//

import UIKit

final class OModesCollectionLayout: UICollectionViewFlowLayout {
    
    private let minimumScale: CGFloat = 0.85

    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    override func prepare() {
        super.prepare()
        collectionView?.decelerationRate = .fast
        if let collectionView = collectionView {
            let rightInset = collectionView.bounds.width / 2 - itemSize.width / 2
            collectionView.contentInset = UIEdgeInsets(top: 0, left: rightInset, bottom: 0, right: rightInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            guard let collectionView = collectionView else { return proposedContentOffset }
        
        let width = itemSize.width + minimumLineSpacing
        var offset = proposedContentOffset.x + collectionView.contentInset.left
        
        if velocity.x > 0 {
          offset = width * ceil(offset / width)
        } else if velocity.x == 0 {
          offset = width * round(offset / width)
        } else if velocity.x < 0 {
          offset = width * floor(offset / width)
        }
        return CGPoint(x: offset - collectionView.contentInset.left, y: 0)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView, let array = super.layoutAttributesForElements(in: rect) else { return nil }
        return array.map { attrs in
            guard attrs.representedElementCategory == .cell else { return attrs }
            let attrs = attrs.copy() as! UICollectionViewLayoutAttributes
            let distance = abs(collectionView.contentOffset.x + collectionView.contentInset.right - attrs.frame.origin.x)
            let scale = min(max(1 - distance / (collectionView.bounds.width), minimumScale), 1)
            attrs.transform = CGAffineTransform(scaleX: scale, y: scale)
            return attrs
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
