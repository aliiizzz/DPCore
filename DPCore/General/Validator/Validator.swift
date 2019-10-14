//
//  Validator.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-24.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct Validator {
    static let schemePrefix = "dgpsdk"
    static let digiPayScheme = "dgp"
    
    static func hasValidURLScheme() -> Bool {
        let prefix = schemePrefix
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] else { return false }
        return urlTypes.reduce(false) {
            guard let schemes = $1["CFBundleURLSchemes"] as? [String] else { return $0 }
            return $0 || schemes.reduce(false) { $0 || ($1.hasPrefix(prefix) && $1.count > prefix.count) }
        }
    }
    
    static func hasValidLSApplicationQueries() -> Bool {
        guard let queries = Bundle.main.infoDictionary?["LSApplicationQueriesSchemes"] as? [String] else { return false }
        return queries.reduce(false) { $0 || $1 == digiPayScheme }
    }
    
}
