//
//  Source.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-14.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct Source: Encodable {
    var value: String
    var type: Int
    var expireDate: String
    var prefix: String
    var postfix: String
}
