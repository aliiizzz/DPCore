//
//  Collections+Extension.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/14/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Optional isEmpty for Collections such as Array and Dictionary
extension Optional where Wrapped == Collection {
    
    var isEmpty: Bool {
    
        switch self {
        case .some(let collection):
            return collection.isEmpty
        default:
            return true
        }
        
    }
}
