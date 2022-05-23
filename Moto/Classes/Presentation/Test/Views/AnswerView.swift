//
//  AnswerView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import UIKit
import RxCocoa
import Kingfisher

final class AnswerView: UIView {
    private lazy var answerLabel = makeAnswerLabel()
    private lazy var imageView = makeImageView()
    private lazy var preloader = makePreloader()
    private var labelBottomConstraint: NSLayoutConstraint?
    
    var state: State = .initial {
        didSet {
            setState(state: state)
        }
    }
        
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AnswerView {
    enum State {
        case initial, correct, error, warning, selected
    }
    
    func setAnswer(answer: String, image: URL?) {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 18.scale))
            .lineHeight(25.scale)
        
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
        preloader.stopAnimating()
        
        if let imageUrl = image {
            needUpdateConstraints()
            
            preloader.startAnimating()
        
            imageView.kf.setImage(with: imageUrl, completionHandler: { [weak self] _ in
                self?.preloader.stopAnimating()
            })
        }
        
        answerLabel.attributedText = answer.attributed(with: attrs)
    }
}

// MARK: Private
private extension AnswerView {
    func initialize() {
        layer.cornerRadius = 20.scale
        state = .initial
    }
    
    func setState(state: State) {
        switch state {
        case .initial:
            layer.borderColor = TestPalette.Answer.initialBorder.cgColor
            backgroundColor = TestPalette.Answer.initialBackground
            answerLabel.textColor = TestPalette.Answer.text
            layer.borderWidth = 3.scale
        case .selected:
            layer.borderColor = TestPalette.Answer.selectedBorder.cgColor
            backgroundColor = TestPalette.Answer.initialBackground
            answerLabel.textColor = TestPalette.Answer.text
            layer.borderWidth = 3.scale
        case .correct:
            backgroundColor = TestPalette.Answer.correctBackground
            answerLabel.textColor = TestPalette.Answer.selectedText
            layer.borderWidth = 0
        case .error:
            backgroundColor = TestPalette.Answer.incorrectBackground
            answerLabel.textColor = TestPalette.Answer.selectedText
            layer.borderWidth = 0
        case .warning:
            backgroundColor = TestPalette.Answer.warningBackground
            answerLabel.textColor = TestPalette.Answer.text
            layer.borderWidth = 3.scale
            layer.borderColor = TestPalette.Answer.warningBorder.cgColor
        }
    }
}

// MARK: Make constraints
private extension AnswerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            answerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            answerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            answerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale)
        ])
        
        labelBottomConstraint = answerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        labelBottomConstraint?.isActive = true
    }
    
    func needUpdateConstraints() {
        labelBottomConstraint?.isActive = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 124.scale),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        labelBottomConstraint = imageView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 10.scale)
        labelBottomConstraint?.isActive = true
    }
}

// MARK: Lazy initialization
private extension AnswerView {
    func makeAnswerLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 24.scale, height: 24.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
