//
//  CourseCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 10.04.2021.
//

import UIKit

class CourseCell: UICollectionViewCell {
    private lazy var overlayView = makeOverlay()
    private lazy var progressView = makeProgressView()
    private lazy var nameLabel = makeCourseNameLabel()
    private lazy var testsCountLabel = makeTestsCountLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CourseCell {
    func setup(element: CourseElement) {
        progressView.setProgres(percent: element.course.progress)
        overlayView.tintColor = element.isSelected
            ? StudyPalette.Course.selected
            : StudyPalette.Course.deselected
        
        let titleColor = element.isSelected
            ? StudyPalette.Course.selectedText
            : StudyPalette.Course.title
        
        let subtitleColor = element.isSelected
            ? StudyPalette.Course.selectedText
            : StudyPalette.Course.subtitle
        
        nameLabel.attributedText = element.course.name.attributed(with: TextAttributes.titleAttrs.textColor(titleColor))
        testsCountLabel.attributedText = String(format: "Study.Course.CourseCount".localized, element.course.testCount).attributed(with: TextAttributes.subtitleAttrs.textColor(subtitleColor))
    }
}

// MARK: Private
private extension CourseCell {
    func initialize() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension CourseCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: progressView.centerYAnchor, constant: 8.scale),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 59.scale),
            progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor),
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.scale),
            progressView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 42.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: testsCountLabel.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: testsCountLabel.rightAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: testsCountLabel.topAnchor, constant: -4.scale)
        ])
        
        NSLayoutConstraint.activate([
            testsCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.scale),
            testsCountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.scale),
            testsCountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.scale),
        ])
    }
}

// MARK: Lazy initialization
private extension CourseCell {
    func makeOverlay() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Study.CourseOverlay")
        view.contentMode = .scaleToFill
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> CourseCellProgressView {
        let view = CourseCellProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCourseNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        contentView.addSubview(view)
        return view
    }
    
    func makeTestsCountLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        contentView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let titleAttrs = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 20.scale))
        .lineHeight(28.scale)
    
    static let subtitleAttrs = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 16.scale))
        .lineHeight(22.scale)
}
