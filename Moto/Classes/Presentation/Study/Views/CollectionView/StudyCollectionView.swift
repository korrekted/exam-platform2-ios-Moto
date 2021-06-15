//
//  StudyCollectionView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 30.01.2021.
//

import UIKit
import RxCocoa

final class StudyCollectionView: UICollectionView {
    lazy var selectedCourse = BehaviorRelay<Course?>(value: nil)
    lazy var didTapSelectedCourse = PublishRelay<Course>()
    lazy var didTapTrophy = PublishRelay<Void>()
    lazy var selectedMode = PublishRelay<SCEMode.Mode>()
    lazy var didTapFlashcards = PublishRelay<Void>()
    
    private lazy var sections = [StudyCollectionSection]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension StudyCollectionView {
    func setup(sections: [StudyCollectionSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension StudyCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .title(let title):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCTitleCell.self), for: indexPath) as! SCTitleCell
            cell.setup(title: title)
            return cell
        case .mode:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCModesCell.self), for: indexPath) as! SCModesCell
            cell.setup()
            cell.selectedMode = { [weak self] in
                self?.selectedMode.accept($0)
            }
            return cell
        case .courses(let elements):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCCoursesCell.self), for: indexPath) as! SCCoursesCell
            cell.setup(
                elements: elements,
                selectedCourse: { [weak self] in self?.selectedCourse.accept($0) },
                didTapCell: { [weak self] in self?.didTapSelectedCourse.accept($0) }
            )
            return cell
        case .trophy:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCTrophyCollectionCell.self), for: indexPath) as! SCTrophyCollectionCell
            return cell
        case .flashcards(let flashcards):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCFlashcardsCell.self), for: indexPath) as! SCFlashcardsCell
            cell.setup(flashcards: flashcards)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegate
extension StudyCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch sections[indexPath.section].elements[indexPath.row] {
        case .title:
            return CGSize(width: collectionView.bounds.width, height: 24.scale)
        case .mode:
            return CGSize(width: collectionView.bounds.width, height: 472.scale)
        case .courses:
            return CGSize(width: collectionView.bounds.width, height: 232.scale)
        case .trophy:
            return CGSize(width: collectionView.bounds.width, height: 168.scale)
        case .flashcards:
            return CGSize(width: collectionView.bounds.width, height: 140.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .trophy:
            didTapTrophy.accept(Void())
        case .flashcards:
            didTapFlashcards.accept(Void())
        default:
            break
        }
    }
}

// MARK: Private
private extension StudyCollectionView {
    func initialize() {
        register(SCTitleCell.self, forCellWithReuseIdentifier: String(describing: SCTitleCell.self))
        register(SCModesCell.self, forCellWithReuseIdentifier: String(describing: SCModesCell.self))
        register(SCTrophyCollectionCell.self, forCellWithReuseIdentifier: String(describing: SCTrophyCollectionCell.self))
        register(SCCoursesCell.self, forCellWithReuseIdentifier: String(describing: SCCoursesCell.self))
        register(SCFlashcardsCell.self, forCellWithReuseIdentifier: String(describing: SCFlashcardsCell.self))
        
        dataSource = self
        delegate = self
    }
}
