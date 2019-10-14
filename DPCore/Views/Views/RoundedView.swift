//
//  RoundedView.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/11/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    
    var roundingCorners: UIRectCorner = .allCorners {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerRadiusSize: CGSize = .zero {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var roundedBackground: UIColor? = .white {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var roundingEdgeInset: UIEdgeInsets = .zero {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var borderWidth: Float = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? = .clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        super.draw(rect)
        self.backgroundColor = .clear
        var roundingBgColor: UIColor
        
        if let backColor = self.roundedBackground {
            roundingBgColor = backColor
        }
        else {
            roundingBgColor = .clear
        }
        
        var borderColor: UIColor = .clear
        
        if let bdrColor = self.borderColor {
            borderColor = bdrColor
        }
        
        var roundedRect = UIEdgeInsetsInsetRect(rect, self.roundingEdgeInset)
        
        if self.borderWidth > 0.0001 {
            let padding = CGFloat(self.borderWidth / 2)
            let paddingEdgeInsets = UIEdgeInsets.init(top: padding, left: padding, bottom: padding, right: padding)
            roundedRect = UIEdgeInsetsInsetRect(roundedRect, paddingEdgeInsets)
        }
        
        let path = UIBezierPath.init(roundedRect: roundedRect, byRoundingCorners: self.roundingCorners, cornerRadii: self.cornerRadiusSize)
        
        roundingBgColor.setFill()
        path.fill()
        borderColor.setStroke()
        path.lineWidth = CGFloat(self.borderWidth)
        path.stroke()
        
    }

}
