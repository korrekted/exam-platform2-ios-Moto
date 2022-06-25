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
    enum State {
        case initial, correct, error, warning, selected
    }
    
    var state: State = .initial {
        didSet {
            setState(state: state)
        }
    }
    
    lazy var answerLabel = makeAnswerLabel()
    lazy var imageView = makeImageView()
    lazy var preloader = makePreloader()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    private lazy var labelBottomConstraint = NSLayoutConstraint()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AnswerView {
    func setAnswer(answer: String, image: URL?) {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20.scale)
        answerLabel.attributedText = answer.attributed(with: attrs)
        
        setup(image: image)
    }
    
    func setAnswer(answerHtml: String, image: URL?) {
        answerLabel.attributedText = attributedString(for: answerHtml)
        
        setup(image: image)
    }
    
    var didTap: Signal<Void> {
        tapGesture.rx.event
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
    }
}

// MARK: Private
private extension AnswerView {
    func initialize() {
        layer.cornerRadius = 12.scale
        addGestureRecognizer(tapGesture)
        
        state = .initial
    }
    
    func setup(image: URL?) {
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
        preloader.stopAnimating()
        
        if let imageUrl = image {
            preloader.startAnimating()
        
            imageView.kf.setImage(with: imageUrl, completionHandler: { [weak self] _ in
                self?.preloader.stopAnimating()
            })
            
            needUpdateConstraints()
        }
    }
    
    func setState(state: State) {
        switch state {
        case .initial:
            layer.borderColor = TestPalette.Answer.initialBorder.cgColor
            backgroundColor = TestPalette.Answer.initialBackground
            answerLabel.textColor = TestPalette.Answer.text
            layer.borderWidth = 2.scale
        case .selected:
            layer.borderColor = TestPalette.Answer.selectedBorder.cgColor
            backgroundColor = TestPalette.Answer.initialBackground
            answerLabel.textColor = TestPalette.Answer.text
            layer.borderWidth = 2.scale
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
            layer.borderWidth = 2.scale
            layer.borderColor = TestPalette.Answer.warningBorder.cgColor
        }
    }
    
    func attributedString(for htmlString: String) -> NSAttributedString? {
        guard !htmlString.isEmpty else { return nil }
        
        let font = Fonts.SFProRounded.regular(size: 17.scale)
        let htmlWithStyle = "<span style=\"font-family: \(font.fontName); font-style: regular; font-size: \(17.scale)px; line-height: \(20.scale)px;\">\(htmlString)</span>"
        let data = Data(htmlWithStyle.utf8)
        
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        
        return attributedString
    }
}

// MARK: Make constraints
private extension AnswerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            answerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            answerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            answerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        labelBottomConstraint = answerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        labelBottomConstraint.isActive = true
    }
    
    func needUpdateConstraints() {
        labelBottomConstraint.isActive = false
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
        labelBottomConstraint.isActive = true
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
