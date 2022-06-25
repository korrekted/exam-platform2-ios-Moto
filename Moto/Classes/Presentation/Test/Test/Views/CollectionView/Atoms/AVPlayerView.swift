//
//  AVPlayerView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 10.02.2021.
//

import AVFoundation
import UIKit

class AVPlayerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
        
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

}

private extension AVPlayerView {
    func initialize() {
        backgroundColor = .black
        isUserInteractionEnabled = false
        playerLayer.videoGravity = .resizeAspectFill
        clipsToBounds = true
    }
}
