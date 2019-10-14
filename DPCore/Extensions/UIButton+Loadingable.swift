//
//  UIButton+Loadingable.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-05.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

extension UIButton {
    
    private struct AssociatedKeys {
        static var ButtonText = "loading_buttonText"
        static var IndicatorView = "loading_indicatorView"
        static var ButtonIsEnabled = "loading_isEnabled"
    }
    
    private var buttonText: String? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ButtonText) as? String
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.ButtonText, value, .OBJC_ASSOCIATION_COPY)
        }
        
    }
    
    private var indicatorView: UIActivityIndicatorView? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.IndicatorView) as? UIActivityIndicatorView
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.IndicatorView, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
    private var buttonisEnabled: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ButtonIsEnabled) as? Bool ?? self.isEnabled
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.ButtonIsEnabled, value, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    open func loadingIndicator(_ show: Bool, _ tag: Int = -1500) {
        
        if show, indicatorView == nil {
            self.buttonisEnabled = self.isEnabled
            self.isEnabled = false
            self.alpha = 0.5
            
            let indicator = UIActivityIndicatorView(frame: self.frame)
            indicator.color = .black
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            self.buttonText = title(for: .normal) ?? titleLabel?.text ?? ""
            setTitle("", for: .normal)
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.hidesWhenStopped = true
            indicatorView = indicator
            
            indicatorView?.startAnimating()
            
        }
        else if !show, let indicatorView = indicatorView, indicatorView.isAnimating {
            
            indicatorView.stopAnimating()
            indicatorView.removeFromSuperview()
            setTitle(self.buttonText, for: .normal)
            self.isEnabled = self.buttonisEnabled
            self.alpha = 1.0
            self.indicatorView = nil
            
        }
    }
}
