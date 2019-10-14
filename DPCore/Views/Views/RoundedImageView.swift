//
//  RoundedImageView.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/13/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

/// <#Description#>
@IBDesignable
class RoundedImageView: UIImageView {
    
    /// <#Description#>
    @IBInspectable
    var cornerRadius: Float = 0.0 {
        didSet {
            self.clipsToBounds = true
            self.layer.cornerRadius = CGFloat(self.cornerRadius)
            setNeedsLayout()
            
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
