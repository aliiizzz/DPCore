//
//  ResponseResult.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct ResponseResult: Decodable {
    var title: String?
    var status: Int
    var message: String
    let level: ServerErrorLevel?
}
