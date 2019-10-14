//
//  ReceiptHeaderView.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/11/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

/// <#Description#>
class ReceiptHeaderView: GradientView {

    /// <#Description#>
    @IBOutlet fileprivate weak var  titleLabel: UILabel!
    
    /// config and setup layout when view load from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = nil

    }
    
    /// config and filled title
    ///
    /// - Parameter title: a <b>`String`<b> object represet for status
    func config(title: String) {
        self.titleLabel.text = title
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
