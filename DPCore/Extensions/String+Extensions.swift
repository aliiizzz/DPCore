//
//  String+Extensions.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/20/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

// MARK: - <#OptionalString#>
extension Optional where Wrapped == String {
    
    var isEmptyOrBlank: Bool {
        switch self {
        case .some(let aString):
            return aString.isEmptyOrBlank
        case .none:
            return true
        }
    }
    
}

// MARK: - <#Description#>
extension String {
    
    var isEmptyOrBlank: Bool {
        return self.isEmptyOrBlankString()
    }
    
    func isEmptyOrBlankString() -> Bool {
        
        guard !self.isEmpty else { return true}
        
        guard self.trimmingCharacters(in: CharacterSet.whitespaces).count != 0 else {
            return true
        }
    
        guard self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0 else {
            return true
        }
        
        return false
    }
    
}
