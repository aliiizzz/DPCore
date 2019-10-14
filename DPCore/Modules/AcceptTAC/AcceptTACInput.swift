//
//  AcceptTACInput.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-15.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct AcceptTACInput {
    let ticket: String
    let tacResponse: TACResponse
    let tacURL: URL
}
