//
//  BottomSheetAnimation.swift
//  DMV
//
//  Created by Vitaliy Zagorodnov on 02.06.2021.
//

import Foundation
import UIKit

class BottomSheetAnimation: NSObject {
    
    private let duration: Double
    private let animationType: AnimationType
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(duration: Double, animationType: AnimationType) {
        self.duration = duration
        self.animationType = animationType
    }
}

extension BottomSheetAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
        case .present:
            presentAnimation(transitionContext: transitionContext)
        case .dismiss:
            dismissAnimation(transitionContext: transitionContext)
        }
    }
    
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        toView.frame = containerView.frame
        
        
        guard let snapshot = toView.snapshotView(afterScreenUpdates: true) else { return }
        
        toView.isHidden = true
        containerView.addSubview(toView)

        containerView.backgroundColor = .clear
        snapshot.frame.origin.y = snapshot.frame.height
        containerView.addSubview(snapshot)

        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                snapshot.frame.origin.y = 0
            }) {
                toView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                containerView.backgroundColor = .clear
                toView.isHidden = false
                snapshot.removeFromSuperview()
                transitionContext.completeTransition($0)
            }
    }
    
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
    
        fromView.backgroundColor = .clear
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        guard let snapshot = fromView.snapshotView(afterScreenUpdates: true) else {
            return
        }

        containerView.addSubview(snapshot)
        
        fromView.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                containerView.backgroundColor = .clear
                snapshot.frame.origin.y = snapshot.frame.height
            }) {
                snapshot.removeFromSuperview()
                transitionContext.completeTransition($0)
            }
    }
    
}

