//
//  FlashCardView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 12.06.2021.
//

import UIKit
import AVFoundation

protocol FlashCardDelegate: AnyObject {
    func moving(index: Int, distance: CGFloat)
    func moved()
    func cardReturned()
    func tapAction(id: Int, isKnew: Bool)
}

class FlashCardView: UIView {
    var index: Int!
    
    weak var delegate: FlashCardDelegate?
    
    private var xCenter: CGFloat = .zero
    private var yCenter: CGFloat = .zero
    private var originalPoint: CGPoint = .zero
    private var id: Int?
    private var player: AVPlayer?
    
    private lazy var progressLabel = makeProgress()
    private lazy var questionLabel = makeQuestionLabel()
    private lazy var answerLabel = makeAnswerLabel()
    private lazy var scrollView = makeScrollView()
    private lazy var stackView = makeStackView()
    private lazy var bottomButton = makeButton()
    private lazy var topButton = makeButton()
    
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
extension FlashCardView {
    
    func setup(element: FlashCardModel) {
        id = element.id
        progressLabel.attributedText = element.progress.attributed(with: .progressAttr)
        questionLabel.attributedText = attributedString(for: element.question, attr: .questionAttr, style: "bold")
        answerLabel.attributedText = attributedString(for: element.answer, attr: .answerAttr, style: "normal")
        topButton.backgroundColor = element.knew ? FlashcardPalette.Card.selectedButton :  FlashcardPalette.Card.initialButton
        topButton.setTitleColor(element.knew ? FlashcardPalette.Card.buttonTintSelected : FlashcardPalette.Card.buttonTintDeselected, for: .normal)
        configureContent(content: element.content)
    }
    
    func playVideo() {
        player?.play()
    }
}

// MARK: Private
private extension FlashCardView {
    func initialize() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        
        layer.cornerRadius = 16.scale
        backgroundColor = FlashcardPalette.Card.background
        
        topButton.isHidden = true
        topButton.transform = CGAffineTransform(translationX: 0, y: 40.scale)
        topButton.addTarget(self, action: #selector(tapKnew), for: .touchUpInside)
        topButton.setTitle("Flashcards.Knew".localized, for: .normal)
        
        bottomButton.addTarget(self, action: #selector(tapBottom), for: .touchUpInside)
        bottomButton.backgroundColor = FlashcardPalette.Card.initialButton
        bottomButton.setTitle("Flashcards.ShowAnswer".localized, for: .normal)
    }
    
    func attributedString(for string: String, attr: TextAttributes, style: String) -> NSAttributedString? {
        guard let font = attr.font, !string.isEmpty else {
            return string.attributed(with: attr)
        }
        
        let htmlWithStyle = "<span style=\"font-family: \(font.fontName); font-style: \(style); font-size: \(font.pointSize); line-height: 30px;\">\(string)</span>"
        let data = Data(htmlWithStyle.utf8)
        
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        
        return attributedString ?? string.attributed(with: attr)
    }
    
    func configureContent(content: FlashCardModel.Content) {
        var contentView: UIView?
        switch content {
        case let .image(url):
            let imageView = makeImageView()
            contentView = imageView
            let queue = DispatchQueue.global(qos: .utility)
                queue.async { [weak imageView] in
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            imageView?.image = UIImage(data: data)
                        }
                    }
                }
        case let .video(url):
            let videoView = makeVideoView()
            contentView = videoView
            let player = AVPlayer(url: url)
            self.player = player
            videoView.player = player
        case .none:
            contentView = nil
        }
        
        if let contentView = contentView {
            contentView.heightAnchor.constraint(equalToConstant: 160.scale).isActive = true
            stackView.insertArrangedSubview(contentView, at: 0)
        }
    }
    
    @objc func tapKnew(sender: UIButton) {
        if let id = id {
            selectedAnswer(sender: sender, id: id)
        }
    }
    
    @objc func tapBottom(sender: UIButton) {
        if topButton.isHidden {
            UIView.animate(withDuration: 0.2) {
                self.topButton.transform = .identity
                self.topButton.isHidden.toggle()
                self.answerLabel.isHidden.toggle()
                self.bottomButton.setTitle("Flashcards.DintKnow".localized, for: .normal)
            }
        } else {
            if let id = id {
                selectedAnswer(sender: sender, id: id)
            }
        }
    }
    
    func selectedAnswer(sender: UIButton, id: Int) {
        let isKnew = sender === topButton
        topButton.backgroundColor = isKnew ? FlashcardPalette.Card.selectedButton : FlashcardPalette.Card.initialButton
        bottomButton.backgroundColor = !isKnew ? FlashcardPalette.Card.selectedButton : FlashcardPalette.Card.initialButton
        topButton.isUserInteractionEnabled = false
        bottomButton.isUserInteractionEnabled = false
        delegate?.tapAction(id: id, isKnew: isKnew)
        topButton.setTitleColor(isKnew ? FlashcardPalette.Card.buttonTintSelected : FlashcardPalette.Card.buttonTintDeselected, for: .normal)
        bottomButton.setTitleColor(!isKnew ? FlashcardPalette.Card.buttonTintSelected : FlashcardPalette.Card.buttonTintDeselected, for: .normal)
    }
}

// MARK: Make constraints
private extension FlashCardView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24.scale),
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomButton.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: 8.scale),
            bottomButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24.scale),
            bottomButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bottomButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            topButton.leadingAnchor.constraint(equalTo: bottomButton.leadingAnchor),
            topButton.trailingAnchor.constraint(equalTo: bottomButton.trailingAnchor),
            topButton.heightAnchor.constraint(equalTo: bottomButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 16.scale),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13.scale),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13.scale),
            scrollView.bottomAnchor.constraint(equalTo: topButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FlashCardView {
    func makeProgress() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeQuestionLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        stackView.addArrangedSubview(view)
        return view
    }
    
    func makeAnswerLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.isHidden = true
        stackView.addArrangedSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.titleLabel?.font = Fonts.SFProRounded.regular(size: 18.scale)
        view.setTitleColor(FlashcardPalette.Card.buttonTintDeselected, for: .normal)
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeVideoView() -> AVPlayerView {
        let view = AVPlayerView()
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
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 8.scale
        scrollView.addSubview(view)
        return view
    }
}

private extension FlashCardView {
    
    enum Action {
        case left, right, `return`
    }
    
    @objc private func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        
        switch gestureRecognizer.state {
        case .began:
            originalPoint = center
        case .changed:
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            updateOverlay(xCenter)
        case .ended:
            let action: Action
            let moveDirectionDistance = bounds.width / 2 * 0.75
            
            let swipeDistance = bounds.width / 4
            
            if yCenter > swipeDistance {
                action = xCenter > moveDirectionDistance ? .right : .left
            } else {
                action = .return
            }
            cardMoved(action: action)
         default:
            break
        }
    }
    
    func cardMoved(action: Action) {
        guard action != .return else {
            center = originalPoint
            delegate?.cardReturned()
            return
        }
        
        delegate?.moved()
        player?.pause()
        let value: CGFloat = action == .left ? -1 : 1
        let finishPoint = CGPoint(x: value * frame.size.width * 2, y: 2 * yCenter + originalPoint.y)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func updateOverlay(_ distance: CGFloat) {
        delegate?.moving(index: index, distance: distance)
    }
}

extension FlashCardView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Игнорим гестуру в области ответственности UIScrollView
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !scrollView.bounds.contains(touch.location(in: scrollView))
    }
}

private extension TextAttributes {
    static let questionAttr = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 24.scale))
        .textColor(FlashcardPalette.Card.question)
        .textAlignment(.center)
    
    static let answerAttr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 20.scale))
        .textColor(FlashcardPalette.Card.answer)
        .textAlignment(.center)
    
    static let progressAttr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 14.scale))
        .textColor(FlashcardPalette.Card.progress)
}
