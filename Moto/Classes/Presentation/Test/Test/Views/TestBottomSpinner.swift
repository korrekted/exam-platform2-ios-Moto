//
//  TestBottomSpinner.swift
//  CDL
//
//  Created by Андрей Чернышев on 17.05.2022.
//

import UIKit

final class TestBottomSpinner: UIView {
    lazy var spinner = makeSpinner()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TestBottomSpinner {
    func start() {
        isHidden = false
        spinner.startAnimating()
    }
    
    func stop() {
        isHidden = true
        spinner.stopAnimating()
    }
}
    
// MARK: Make constraints
private extension TestBottomSpinner {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestBottomSpinner {
    func makeSpinner() -> Spinner {
        let view = Spinner(size: CGSize(width: 24.scale, height: 24.scale), color: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
