//
//  SIProgressCollectionView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 07.04.2021.
//

import UIKit
import RxCocoa

final class SIProgressCollectionView: UICollectionView {
    lazy var selectedIndex = PublishRelay<Int>()
    
    private lazy var elements = [SIProgressElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SIProgressCollectionView {
    func setup(elements: [SIProgressElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension SIProgressCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SITestProgressCollectionCell.self), for: indexPath) as! SITestProgressCollectionCell
        cell.setup(element: element)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SIProgressCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 35.scale, height: 35.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex.accept(elements[indexPath.row].index)
    }
}

// MARK: Private
private extension SIProgressCollectionView {
    func initialize() {
        register(SITestProgressCollectionCell.self, forCellWithReuseIdentifier: String(describing: SITestProgressCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
