//
//  UIColor_hex.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-22.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// RGB color
    ///
    /// - Parameter hex: Int value with 0xABCDEF representation
    convenience init(hex: UInt) {
        let red = CGFloat(hex >> 16) / 255
        let green = CGFloat((hex >> 8) & 0xff) / 255
        let blue = CGFloat(hex & 0xff) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// initiates a color from hex string
    ///
    /// - Parameter hex: should follow the pattern "#ABCDEF". starts with #
    convenience init(hexStr hex: String) {
        guard hex.first == "#", hex.count == 7, let hexValue = UInt(hex[hex.index(hex.startIndex, offsetBy: 1)...], radix: 16) else {
            self.init(white: 1.0, alpha: 1.0)
            return
        }
        self.init(hex: hexValue)
    }
}
