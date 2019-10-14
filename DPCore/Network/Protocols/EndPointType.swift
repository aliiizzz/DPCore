//
//  EndPointType.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal protocol EndPointType {
    
    var baseURL: String { get }
    var path: URL? { get }
    var headers: HTTPHeaders? { get }
}
