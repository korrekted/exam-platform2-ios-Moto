//
//  OModesCollectionView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 21.06.2021.
//

import UIKit

final class OModesCollectionView: UICollectionView {
    lazy var elements = [OModeCollectionElement]()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension OModesCollectionView {
    func setup(elements: [OModeCollectionElement], isNeedScroll: Bool) {
        self.elements = elements
        CATransaction.setCompletionBlock { [weak self] in
            if isNeedScroll, let index = elements.firstIndex(where: { $0.isSelected }) {
                self?.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: false)
            }
        }
        CATransaction.begin()
        reloadData()
        CATransaction.commit()
    }
}

// MARK: UICollectionViewDelegate
extension OModesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let height = collectionView.bounds.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
        return CGSize(width: flowLayout.itemSize.width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard
            let cell = visibleCells.first(where: { bounds.contains($0.frame) }),
            let indexPath = indexPath(for: cell),
            elements.indices.contains(indexPath.row)
        else {
            return
        }
        
        elements.forEach { $0.isSelected = false }
        elements[indexPath.row].isSelected = true
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension OModesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: OModeCell.self), for: indexPath) as! OModeCell
        cell.setup(element: element)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: Private
private extension OModesCollectionView {
    func initialize() {
        register(OModeCell.self, forCellWithReuseIdentifier: String(describing: OModeCell.self))
        
        dataSource = self
        delegate = self
    }
}

