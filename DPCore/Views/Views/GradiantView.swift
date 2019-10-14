//
//  GradiantView.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-22.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

/**
 Author: Amirhesam Rayatnia <h.rayatnia@gmail.com>
 Version: 1.0.0
 
 کلاس گرادیانت با قابلیت مقدار دهی در Storyboard,xib که به توسعه دهنده کمک می کند با دادن ۲ مقدار رنگ
 و همچنین نقطه شروع و پایان هر رنگ زاویه گرادیانت را مشخص کند
 همچنین می توان به کمک این کلاس بری روی رنگ سایه انداخت
 
 */
@IBDesignable class GradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!/// it's gradiant layer which is an instance of CAGradientLayer
    
    /// top color or start color is the first color
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    /// bottom color or finish color is the second one
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    // shadow variable
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            setNeedsLayout()
        }
    }
    /// shadow X point value
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    /// shadow Y point place
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    /// shadow blur value
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    /// color X start point
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    /// color Y start point
    @IBInspectable var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    /// color X end point
    @IBInspectable var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    /// color Y end point
    @IBInspectable var endPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    /// layer's cornerRadius size
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    /// overriding self value
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    /**
     applying variable to layer
     INPUT : VOID
     OUTPUT : VOID
     see also : `layoutSubviews`
     */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer = self.layer as! CAGradientLayer
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
        
    }
    
    /**
     Parameter duration: duration of animation happening
     Parameter newTopColor: the color which the first color will goes to
     Parameter newBottomColor: the color whic the second color will goes to
     */
    
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.gradientLayer?.add(animation, forKey: "animateGradient")
    }
}
