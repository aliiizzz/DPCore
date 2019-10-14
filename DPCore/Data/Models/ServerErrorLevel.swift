//
//  ServerErrorLevel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-20.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

enum ServerErrorLevel: String, Decodable {

    case INFO = "INFO"
    case WARN = "WARN"
    case BLOCKER = "BLOCKER"
}
