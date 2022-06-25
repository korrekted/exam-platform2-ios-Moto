//
//  QuestionCollectionCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 10.02.2021.
//

import UIKit
import AVFoundation
import RxSwift
import Kingfisher

final class QuestionContentCollectionCell: UICollectionViewCell {
    lazy var questionImageView = makeImageView()
    lazy var videoView = makeVideoView()
    lazy var expandButton = makeExpandButton()
    lazy var preloader = makePreloader()
   
    private lazy var disposeBag = DisposeBag()
    
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
extension QuestionContentCollectionCell {
    func setup(content: QuestionContentCollectionType, didTapExpand: @escaping () -> Void) {
        switch content {
        case let .image(url):
            videoView.isHidden = true
            questionImageView.isHidden = false
            
            preloader.startAnimating()
            
            questionImageView.kf.setImage(with: url, completionHandler: { [weak self] _ in
                self?.preloader.stopAnimating()
            })
        case let .video(url):
            videoView.isHidden = false
            questionImageView.isHidden = true
            
            let player = AVPlayer(url: url)
            videoView.player = player
            player.play()
        }
        
        expandButton.rx.tap
            .bind(onNext: didTapExpand)
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension QuestionContentCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension QuestionContentCollectionCell {
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
            expandButton.heightAnchor.constraint(equalToConstant: 24.scale),
            expandButton.widthAnchor.constraint(equalToConstant: 24.scale),
            expandButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.scale),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionContentCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 20.scale
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeVideoView() -> AVPlayerView {
        let view = AVPlayerView()
        view.layer.cornerRadius = 20.scale
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeExpandButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Question.Expand"), for: .normal)
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
