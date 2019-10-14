//
//  UINavigationController+Rotate.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-21.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

internal extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
