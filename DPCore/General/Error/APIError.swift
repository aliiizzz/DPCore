//
//  APIError.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-13.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

public protocol APIError: Error {
    var message: String { get }
    var code: Int { get }
}
