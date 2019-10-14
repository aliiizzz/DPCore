//
//  BankCardGradientsView.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/19/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

@IBDesignable
class BankCardGradientsView: UIView {
    
    // MARK: - Initialized UI Properties
    /// <#Description#>
    private let lowerGradientsLayer = CAGradientLayer()
    
    /// <#Description#>
    private let middleGradientsLayer = CAGradientLayer()
    /// <#Description#>
    private let upperGradientsLayer = CAGradientLayer()
    
    private let middleGradientsLayerMask = CAShapeLayer()
    private let upperGradientsLayerMask = CAShapeLayer()
    
    private let ColorBurnBenldMode = "colorBurnBlendMode"
    
    // MARK: - Public Properties
    
    /// <#Description#>
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var topColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var bottomColor: UIColor = .blue {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var topPoint: CGPoint = CGPoint(x: 0.5, y: 0.0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var bottomPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
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
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 0, height: -3) {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// shadow blur value
    @IBInspectable
    var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Override Methods
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientsLayers()
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        
        if self.lowerGradientsLayer.superlayer == nil {
            self.layer.addSublayer(self.lowerGradientsLayer)
        }
        
        if self.middleGradientsLayer.superlayer == nil {
            
            middleGradientsLayer.mask = self.middleGradientsLayerMask
            
            self.layer.addSublayer(self.middleGradientsLayer)
        }
        
        if self.upperGradientsLayer.superlayer == nil {
            
            upperGradientsLayer.mask = self.upperGradientsLayerMask
            
            self.layer.addSublayer(self.upperGradientsLayer)
        }
        
        self.middleGradientsLayer.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1).cgColor]
        self.upperGradientsLayer.colors = self.middleGradientsLayer.colors
        
        self.middleGradientsLayer.compositingFilter = ColorBurnBenldMode
        self.upperGradientsLayer.compositingFilter = ColorBurnBenldMode
        
    }
    
    private func updateGradientsLayers() {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
        
        updateGradientsFrame()
        updateGradientsPoints()
        updateMaskFrames()
        
        self.lowerGradientsLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        
    }
    
    private func updateGradientsFrame() {
        
        self.lowerGradientsLayer.frame = self.bounds
        self.middleGradientsLayer.frame = self.bounds
        self.upperGradientsLayer.frame = self.bounds
        
    }
    
    private func updateGradientsPoints() {
        
        let startPoint = self.topPoint
        let endPoint = self.bottomPoint
        
        self.lowerGradientsLayer.startPoint = startPoint
        self.lowerGradientsLayer.endPoint = endPoint
        
        self.middleGradientsLayer.startPoint = startPoint
        self.middleGradientsLayer.endPoint = endPoint
        
        self.upperGradientsLayer.startPoint = startPoint
        self.upperGradientsLayer.endPoint = endPoint
        
    }
    
    private func updateMaskFrames() {
        
        let middlePath = UIBezierPath()
        middlePath.move(to: CGPoint(x: 0, y: 0))
        middlePath.addLine(to: CGPoint(x: self.bounds.width * 0.27, y: 0))
        middlePath.addLine(to: CGPoint(x: self.bounds.width * 0.75, y: self.bounds.height))
        middlePath.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        middlePath.addLine(to: CGPoint(x: 0, y: 0))
        
        middleGradientsLayerMask.path = middlePath.cgPath
        middleGradientsLayerMask.frame = self.bounds
        
        let upperPath = UIBezierPath()
        
        upperPath.move(to: CGPoint(x: 0, y: 0))
        upperPath.addLine(to: CGPoint(x: self.bounds.width * 0.15, y: 0))
        upperPath.addLine(to: CGPoint(x: self.bounds.width * 0.40, y: self.bounds.height))
        upperPath.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        upperPath.addLine(to: CGPoint(x: 0, y: 0))
        
        upperGradientsLayerMask.path = upperPath.cgPath
        upperGradientsLayerMask.frame = self.bounds
        
    }
    
}
