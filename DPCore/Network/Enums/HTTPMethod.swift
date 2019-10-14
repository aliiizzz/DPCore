//
//  HTTPMethod.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

/// HTTPMethods
///
/// - get: GET method
/// - post: POST method
/// - put: PUT method
/// - patch: PATCH method
/// - delete: delete method
internal enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
