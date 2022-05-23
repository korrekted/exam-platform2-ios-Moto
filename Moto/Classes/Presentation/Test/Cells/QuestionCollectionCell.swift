//
//  QuestionCollectionCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 10.02.2021.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import Kingfisher

class QuestionCollectionCell: UICollectionViewCell {
    
    private lazy var questionImageView = makeImageView()
    lazy var videoView = makeVideoView()
    lazy var expandButton = makeExpandButton()
    lazy var preloader = makePreloader()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        questionImageView.image = nil
        questionImageView.kf.cancelDownloadTask()
        
        preloader.stopAnimating()
        
        disposeBag = DisposeBag()
    }
}

// MARK: Public
extension QuestionCollectionCell {
    func setup(content: QuestionContentType, didTapExpand: @escaping () -> Void) {
        switch content {
        case let .image(url):
            videoView.isHidden = true
            questionImageView.isHidden = false
            
            preloader.startAnimating()
            
            questionImageView.kf.setImage(with: url, completionHandler: { [weak self] _ in
                self?.preloader.stopAnimating()
            })
        case let .video(url):
            let player = AVPlayer(url: url)
            videoView.player = player
            videoView.isHidden = false
            questionImageView.isHidden = true
            player.play()
        }
        
        expandButton.rx.tap
            .bind(onNext: didTapExpand)
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension QuestionCollectionCell {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension QuestionCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            questionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            questionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            questionImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            questionImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            videoView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            videoView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            expandButton.heightAnchor.constraint(equalToConstant: 15.scale),
            expandButton.widthAnchor.constraint(equalTo: expandButton.heightAnchor),
            expandButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.scale),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 20.scale
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }
    
    func makeVideoView() -> AVPlayerView {
        let view = AVPlayerView()
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }
    
    func makeExpandButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Question.Expand"), for: .normal)
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 24.scale, height: 24.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
