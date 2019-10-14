//
//  Modal.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-08-03.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

import UIKit

protocol Modal {
    func show(animated: Bool, place: CGPoint?)
    func dismiss(animated: Bool)
    var backgroundView: UIView {get}
    var dialogView: UIView {get set}
    var backgroundShadow: UIColor { get set }
    var timeInterval: Double? {get set }
}

extension Modal where Self: UIView {
    
    func show(animated: Bool, place: CGPoint?) {
        var place = place
        DispatchQueue.main.async {
            
//            guard let `self` = self else { return }
            
            self.backgroundView.alpha = 0
            if let topController = UIApplication.shared.delegate?.window??.rootViewController {
                
                let presentedViewController = topController.topPresentedViewController()
                
                if self is CustomModalView {
                    self.frame = presentedViewController.view.bounds
                    var dialogFrame = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
                    dialogFrame.size.height = self.dialogView.frame.height
                    self.dialogView.frame = dialogFrame
                }
                
                self.dialogView.center  =  CGPoint(x: presentedViewController.view.center.x, y: presentedViewController.view.bounds.height + 250)
                presentedViewController.view.addSubview(self)
                
                if UI_USER_INTERFACE_IDIOM() == .pad, presentedViewController.view.bounds.height < (place?.y ?? 0) {
                    place = presentedViewController.view.center
                    place?.y *= 1.9
                }
                
            }
            
            if animated {
                
                UIView.animate(withDuration: 0.33, animations: {
                    self.backgroundView.alpha = 0.5
                })
                
                UIView.animate(withDuration: 0.33, delay: 0, options: .transitionCurlDown, animations: {
                    if let mode = place {
                        self.dialogView.center  = mode
                    }
                    else {
                        self.dialogView.center  = self.center
                    }
                }, completion: nil)
            }
            else {
                self.backgroundView.alpha = 0.5
                self.dialogView.center  = self.center
            }
            if let time = self.timeInterval {
                self.dismissWithDuration(time)
            }
        }
    }
    
    func dismissWithDuration(_ value: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + value, execute: { [weak self] in
            self?.dismiss(animated: true)
        })
    }
    
    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (_) in
                
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
        else {
            self.removeFromSuperview()
        }
        
    }
}
