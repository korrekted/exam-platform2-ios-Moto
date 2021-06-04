//
//  CourseCellProgressView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 13.04.2021.
//

import UIKit

class CourseCellProgressView: UIView {
    private lazy var progressLabel = makeProgressLabel()
    
    private lazy var circularShareLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let trackLayer = CAShapeLayer()
        let lineWidth: CGFloat = 4
        
        [trackLayer, circularShareLayer].forEach {
            $0.bounds = rect
            $0.position = CGPoint(x: rect.width / 2, y: rect.height / 2)
        }
        
        let circularPath = UIBezierPath(
            arcCenter: circularShareLayer.position,
            radius: rect.width / 2,
            startAngle: -.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        )
        
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = StudyPalette.Course.deselected.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = nil
        trackLayer.lineCap = .round
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(circularShareLayer)

        circularShareLayer.path = circularPath.cgPath
        circularShareLayer.strokeColor = StudyPalette.Course.selected.cgColor
        circularShareLayer.lineWidth = lineWidth
        circularShareLayer.fillColor = nil
        circularShareLayer.lineCap = .round
    }
}

extension CourseCellProgressView {
    func setProgres(percent: Int) {
        progressLabel.text = "\(percent)%"
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circularShareLayer.strokeEnd = min(CGFloat(Double(percent) / 100), 1.0)
        CATransaction.commit()
    }
}

// MARK: Make constraints
private extension CourseCellProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CourseCellProgressView {
    func makeProgressLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Fonts.SFProRounded.bold(size: 16.scale)
        view.textColor = StudyPalette.Course.progressText
        view.textAlignment = .center
        addSubview(view)
        return view
    }
}
