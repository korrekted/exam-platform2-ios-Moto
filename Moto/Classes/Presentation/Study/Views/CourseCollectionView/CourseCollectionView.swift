//
//  CourseCollectionView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 10.04.2021.
//

import UIKit

typealias CourseElement = (course: Course, isSelected: Bool)

class CourseCollectionView: UICollectionView {
    
    private var elements = [CourseElement]()
    
    var selectedCourse: ((Course?) -> Void)?
    var didTapCell: ((Course) -> Void)?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CourseCollectionView {
    func setup(elements: [CourseElement], isNeedScroll: Bool) {
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
extension CourseCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let height = collectionView.bounds.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
        return CGSize(width: flowLayout.itemSize.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        didTapCell?(element.course)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let cell = visibleCells.first(where: { bounds.contains($0.frame) }) {
            let row = indexPath(for: cell)?.row ?? 0
            selectedCourse?(elements[safe: row]?.course)
        }
    }
}

// MARK: UICollectionViewDataSource
extension CourseCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CourseCell.self), for: indexPath) as! CourseCell
        cell.setup(element: element)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: Private
private extension CourseCollectionView {
    func initialize() {
        register(CourseCell.self, forCellWithReuseIdentifier: String(describing: CourseCell.self))
        showsHorizontalScrollIndicator = false
        dataSource = self
        delegate = self
    }
}
