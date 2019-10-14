//
//  RequestTimeoutInterval.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal enum RequestTimeoutInterval: Double {
    case long        = 30.0
    case `default`    = 15.0
    case fast        = 5.0
}

let configuration: URLSessionConfiguration = {
    let conf = URLSessionConfiguration.default
    conf.timeoutIntervalForRequest = RequestTimeoutInterval.default.rawValue
    conf.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    conf.timeoutIntervalForResource = RequestTimeoutInterval.long.rawValue
    return conf
}()
