//
//  CALayer+ShadowExtension.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/15/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func makeShadow(offset: CGSize,
                    blur: CGFloat = 0,
                    opacity: Float = 1,
                    spread: CGFloat = 0) {
        
        shadowOpacity = opacity
        shadowOffset = offset
        shadowRadius = blur / 2
        if spread == 0 {
            shadowPath = nil
        }
        else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
}
