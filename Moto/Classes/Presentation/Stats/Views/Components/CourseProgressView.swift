//
//  CourseProgressView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 24.01.2021.
//

import UIKit

class CourseProgressView: UIView {
    private lazy var progressView = makeProgressView()
    private lazy var percentLabel = makePercentLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: Public
extension CourseProgressView {
    func setup(percent: Int, color: UIColor) {
        let attr = TextAttributes()
            .textColor(color)
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.right)
        
        percentLabel.attributedText = "\(percent)%".attributed(with: attr)
        
        progressView.trackTintColor = color.withAlphaComponent(0.3)
        progressView.progressTintColor = color
        progressView.setProgress(min(Float(Double(percent) / 100), 1.0), animated: false)
    }
}

// MARK: Make constraints
private extension CourseProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            percentLabel.topAnchor.constraint(equalTo: topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            percentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            percentLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 3.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CourseProgressView {
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
