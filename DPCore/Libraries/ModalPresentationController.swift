//
//  ModalPresentationController.swift
//  DPCore
//
//  Created by Farshad Mousalou on 12/8/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit
import CoreGraphics

class ModalPresentationController: UIPresentationController {

    static let minimumWidth: CGFloat = 280.0
    
    static let defaultEdgeInset = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
    
    private let dimmingView = UIView()
    private let trackingView = RoundedView()
    
    private let _dismissOnBackgroundTap = UITapGestureRecognizer()
    
    private let keyboardObserver = KeyboardObserver()
    
    var dismissOnBackgroundTap: Bool = true {
        didSet {
            _dismissOnBackgroundTap.isEnabled = dismissOnBackgroundTap
        }
    }
    
    var modalCornerRadius: CGFloat = 8.0 {
        didSet {
            trackingView.cornerRadiusSize = CGSize(width: modalCornerRadius, height: modalCornerRadius)
        }
    }
    
    var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            dimmingView.backgroundColor = backgroundColor.withAlphaComponent(0.5)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return self.calculateframeOfPresentedViewInContainerView()
    }
    
    deinit {
        dimmingView.removeFromSuperview()
        trackingView.removeFromSuperview()
        _dismissOnBackgroundTap.removeTarget(self, action: #selector(dismisHandler(_:)))
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.commonInit()
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else {
            super.presentationTransitionWillBegin()
            return
        }
        
        self.dimmingView.frame = containerView.bounds
        self.dimmingView.alpha = 0.0
        
        containerView.addSubview(dimmingView)
        
        self.trackingView.frame = self.frameOfPresentedViewInContainerView
        self.trackingView.alpha = 0.0
        
//        self.containerView?.addSubview(trackingView)
//
//        if let presentedView = presentedView {
//            trackingView.addSubview(presentedView)
//        }
        
        guard let transitionCoordinator = self.presentedViewController.transitionCoordinator else {
            self.dimmingView.alpha = 1.0
            self.trackingView.alpha = 1.0
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: {[weak self] (_) in
            
            self?.dimmingView.alpha = 1.0
            self?.trackingView.alpha = 1.0
            
        }) { (_) in
            
        }
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard completed else {
            self.dimmingView.removeFromSuperview()
            self.trackingView.removeFromSuperview()
            return
        }
        self.presentedViewController.view.accessibilityElementsHidden = true
        self.presentedView?.accessibilityViewIsModal = true
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification,
                                        self.presentedView)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = self.presentedViewController.transitionCoordinator else {
            self.dimmingView.alpha = 0
            self.trackingView.alpha = 0
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: {[weak self] (_) in
            
            self?.dimmingView.alpha = 0.0
            self?.trackingView.alpha = 0.0
            
        }) { (_) in
            
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        
        if completed {
            self.dimmingView.removeFromSuperview()
            self.trackingView.removeFromSuperview()
            self.presentingViewController.view.accessibilityElementsHidden = false
        }
        
        super.dismissalTransitionDidEnd(completed)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        guard parentSize != .zero else {
            return .zero
        }
        
        var targetSize = parentSize
        
        let preferredContentSize = container.preferredContentSize
        
        if preferredContentSize != .zero {
            
            targetSize = preferredContentSize
            
            if 0 < targetSize.width && targetSize.width < ModalPresentationController.minimumWidth {
                targetSize.width = ModalPresentationController.minimumWidth
            }
            
            targetSize.width = min(targetSize.width, parentSize.width)
            targetSize.height = min(targetSize.height, parentSize.height)
            
        }
        
        targetSize.width = ceil(targetSize.width)
        targetSize.height = ceil(targetSize.height)
        
        return targetSize
        
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        guard let presentView = presentedView, let containerView = self.containerView else { return }
        
        let exsitingSize = presentView.bounds.size
        let newSize = self.size(forChildContentContainer: container, withParentContainerSize: containerView.bounds.size)
        
        guard exsitingSize == newSize else {
            
            let presentedViewFrame = self.frameOfPresentedViewInContainerView
            
            presentView.frame = presentedViewFrame
            trackingView.frame = presentedViewFrame
            
            return
        }
        
    }
    
}

// MARK: - Private Methods
private extension ModalPresentationController {
    
    private func commonInit() {
        dimmingView.backgroundColor = self.backgroundColor
        dimmingView.alpha = 0
        _dismissOnBackgroundTap.addTarget(self, action: #selector(dismisHandler(_:)))
        dimmingView.addGestureRecognizer(_dismissOnBackgroundTap)
        trackingView.cornerRadiusSize = CGSize(width: modalCornerRadius, height: modalCornerRadius)
        trackingView.backgroundColor = .clear
        trackingView.clipsToBounds = true
        observeKeyboard()
    }
    
    @objc
    func dismisHandler(_ sender: UITapGestureRecognizer) {
        
        guard sender.state == .recognized else { return }
        self.presentingViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func observeKeyboard() {
        
        keyboardObserver.observe { [weak self] (event) in
            guard let `self` = self else { return }
            
            switch event.type {
            case .willHide, .willChangeFrame, .willShow :
                
                UIView.animate(withDuration: event.duration,
                               delay: 0.0,
                               options: [.allowUserInteraction, .beginFromCurrentState, event.options],
                               animations: {
                                
                                let frame = self.frameOfPresentedViewInContainerView
                                self.presentedView?.frame = frame
                                self.trackingView.frame = frame
                                
                }, completion: nil)
                
            default:
                break
            }
        }
    }
    
    func calculateframeOfPresentedViewInContainerView() -> CGRect {
        
        guard let containerView = self.containerView, let containerBounds = self.containerView?.bounds.standardized else {
            return super.frameOfPresentedViewInContainerView
        }
        
        var containerSafeAreaInsets = UIEdgeInsets.zero
        
        if #available(iOS 11, *) {
            containerSafeAreaInsets = containerView.safeAreaInsets
        }
        
        containerSafeAreaInsets.top = max(containerSafeAreaInsets.top,
                                          ModalPresentationController.defaultEdgeInset.top)
        containerSafeAreaInsets.bottom = max(containerSafeAreaInsets.bottom,
                                             ModalPresentationController.defaultEdgeInset.bottom)
        containerSafeAreaInsets.left = max(containerSafeAreaInsets.left,
                                          ModalPresentationController.defaultEdgeInset.left)
        containerSafeAreaInsets.right = max(containerSafeAreaInsets.right,
                                          ModalPresentationController.defaultEdgeInset.right)
        
        let standardPresentableBounds = UIEdgeInsetsInsetRect(containerBounds, containerSafeAreaInsets)
        
        var presentedViewFrame: CGRect = .zero
        
        presentedViewFrame.size = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: standardPresentableBounds.size)
        presentedViewFrame.origin.x = containerSafeAreaInsets.left + (standardPresentableBounds.width - presentedViewFrame.width) * 0.5
        presentedViewFrame.origin.y = containerSafeAreaInsets.top + (standardPresentableBounds.height - presentedViewFrame.height) * 0.5
        
        presentedViewFrame.origin.x = floor(presentedViewFrame.origin.x)
        presentedViewFrame.origin.y = floor(presentedViewFrame.origin.y)
        
        return presentedViewFrame
    }
    
}
