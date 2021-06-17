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

class QuestionCollectionCell: UICollectionViewCell {
    
    private lazy var questionImageView = makeImageView()
    lazy var videoView = makeVideoView()
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
        disposeBag = DisposeBag()
    }
}

// MARK: Public
extension QuestionCollectionCell {
    func setup(content: QuestionContentType) {
        switch content {
        case let .image(url):
            videoView.isHidden = true
            questionImageView.isHidden = false
            let queue = DispatchQueue.global(qos: .utility)
                queue.async { [weak self] in
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async {
                            self?.questionImageView.image = UIImage(data: data)
                        }
                    }
                }
        case let .video(url):
            let player = AVPlayer(url: url)
            videoView.player = player
            videoView.isHidden = false
            questionImageView.isHidden = true
            player.play()
        }
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
}
