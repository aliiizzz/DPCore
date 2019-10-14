//
//  RoundedPinImageView.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/6/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation
import UIKit

class RoundedPinImageView: UIImageView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height * 0.5
        self.layer.borderWidth = 2.0
        self.layer.borderColor = SDKColors.blackThirty.cgColor
    }
    
}
