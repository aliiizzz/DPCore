//
//  NumberFormatter.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-22.
//  Copyright © 2018 DigiPay. All rights reserved.
//
//
//  NumberFormatterExtensions.swift
//  Hampay
//
//  Created by Farzad Sharbafian on 4/1/17.
//  Copyright © 2017 HomaPay. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static let persian: NumberFormatter = {
        $0.numberStyle = .none
        $0.locale = Locale(identifier: "fa_IR")
        return $0
    }(NumberFormatter())
    
    static let signed: NumberFormatter = {
        $0.numberStyle = .none
        $0.locale = Locale(identifier: "fa_IR")
        $0.positivePrefix = "+"
        return $0
    }(NumberFormatter())
    
    static let separated: NumberFormatter = {
        $0.numberStyle = .none
        $0.usesGroupingSeparator = true
        $0.groupingSize = 3
        $0.groupingSeparator = "٫"
        return $0
    }(NumberFormatter())
    
    static let persianCurrency: NumberFormatter = {
        $0.numberStyle = .currency
        $0.locale = Locale(identifier: "fa_IR")
        return $0
    }(NumberFormatter())
}

extension BinaryInteger {
    
    var persian: String {
        guard let str = NumberFormatter.persian.string(from: NSNumber(value: hashValue)) else {
            fatalError("NumberFormatter.persian is not configured correclty.")
        }
        return str
    }
    
    var persianPrice: String {
        return NumberFormatter.separated.string(from: NSNumber(value: hashValue))?.persian ?? "٬"
    }
    
}

extension BinaryFloatingPoint {
    
    var persian: String {
        guard let str = NumberFormatter.persian.string(from: NSNumber(value: hashValue)) else {
            fatalError("NumberFormatter.persian is not configured correclty.")
        }
        return str
    }
    
    var persianPrice: String {
        return NumberFormatter.separated.string(from: NSNumber(value: hashValue))?.persian ?? "٬"
    }
}

extension Int {
    
    var persian: String {
        guard let str = NumberFormatter.persian.string(from: NSNumber(value: self)) else {
            fatalError("NumberFormatter.persian is not configured correclty.")
        }
        return str
    }
    
    var persianPrice: String {
        return NumberFormatter.separated.string(from: NSNumber(value: self))?.persian ?? "٬"
    }
    
}

extension Float {
    
    var persian: String {
        guard let str = NumberFormatter.persian.string(from: NSNumber(value: self)) else {
            fatalError("NumberFormatter.persian is not configured correclty.")
        }
        return str
    }
    
    var persianPrice: String {
        return NumberFormatter.separated.string(from: NSNumber(value: self))?.persian ?? "٬"
    }
    
}

extension Double {
    var persian: String {
        guard let str = NumberFormatter.persian.string(from: NSNumber(value: self)) else {
            fatalError("NumberFormatter.persian is not configured correclty.")
        }
        return str
    }
}
