//
//  BorderButton.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-22.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit
@IBDesignable
class BorderedButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var defaultColor: UIColor = .clear {
        didSet {
            
            if isEnabled {
                setNeedsLayout()
                backgroundColor = self.defaultColor
                shadowEnable()
            }
            
        }
    }
    
    @IBInspectable
    var disabledColor: UIColor = .clear {
        didSet {
            if !isEnabled {
                shadowDisable()
                setNeedsLayout()
                backgroundColor = self.disabledColor
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            }
            else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var customShadowRadius: CGFloat = 0
    
    @IBInspectable
    var customShadowOpacity: Float  = 0
    
    @IBInspectable
    var customShadowOffset: CGSize = CGSize(width: 0, height: 0)
    
    override var isEnabled: Bool {
        didSet {
            
            if isEnabled {
                setNeedsLayout()
                backgroundColor = self.defaultColor
                shadowEnable()
                
            }
            else {
                shadowDisable()
                setNeedsLayout()
                backgroundColor = self.disabledColor
            }
            
            let borderW = self.borderWidth
            self.borderWidth = 0.0
            self.borderWidth = borderW
            
        }
    }
    
    private func shadowEnable() {
        layer.shadowOffset = customShadowOffset
        layer.shadowOpacity = customShadowOpacity
        layer.shadowRadius = customShadowRadius
    }
    private func shadowDisable() {
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
    }
    
    func innerBorder() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.35, height: 0.8)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
        layer.cornerRadius = 8.0
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if isEnabled {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
            }
            return nil
        }
        set {
            if newValue != nil && isEnabled {
                layer.shadowColor = newValue?.cgColor
            }
            else {
                layer.shadowColor = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
