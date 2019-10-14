//
//  ModalTransitionController.swift
//  DPCore
//
//  Created by Farshad Mousalou on 12/8/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit

private let ModalTransitionDuration: TimeInterval = 0.27

class ModalTransitionController: NSObject {
    
    var duration: TimeInterval = ModalTransitionDuration
    
    required init(duration: TimeInterval = ModalTransitionDuration) {
        super.init()
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        var fromView = transitionContext.view(forKey: .from)
        
        if fromView == nil {
            fromView = fromViewController?.view
        }
        
        let toViewController = transitionContext.viewController(forKey: .to)
        var toView = transitionContext.view(forKey: .to)
       
        if toView == nil {
            toView = toViewController?.view
        }
        
        let toPresentingViewController = toViewController?.presentingViewController
        let presenting = toPresentingViewController == fromViewController ? true : false
        
        let animatingViewController = presenting ? toViewController : fromViewController
        let animatingView = presenting ? toView : fromView
        
        let containerView = transitionContext.containerView
        
        if presenting, let toView = toView {
            containerView.addSubview(toView)
        }
        
        let startingCenterY = presenting ? containerView.bounds.maxY : containerView.center.y
        let endingCenterY = !presenting ? containerView.bounds.maxY : containerView.center.y
        
        let startingAlpha: CGFloat = presenting ? 0 : 1
        let endingAlpha: CGFloat = presenting ? 1 : 0
        
        if let animatingViewController = animatingViewController {
            let finalFrame = transitionContext.finalFrame(for: animatingViewController)
            animatingView?.frame = finalFrame
            let height = presenting ? finalFrame.height : 0
            animatingView?.center = CGPoint(x: containerView.center.x, y: startingCenterY + height)
        }
        
        animatingView?.alpha = startingAlpha
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState],
                       animations: {
                        if var height = animatingView?.bounds.height {
                            height = !presenting ? height : 0
                            animatingView?.alpha = endingAlpha
                            animatingView?.center = CGPoint(x: containerView.center.x, y: endingCenterY + height)
                        }
                        
        }) { _ in
            
            if !presenting {
                fromView?.removeFromSuperview()
            }
            
            transitionContext.completeTransition(true)
        }
        
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

// MARK: - <#UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate#>
extension ModalTransitionController: UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {}
