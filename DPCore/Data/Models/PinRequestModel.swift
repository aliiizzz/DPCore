//
//  PinRequestModel.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/8/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

struct PinRequestModel: Codable {
    
    let username: String
    let password: String
    let features: [ProtectedFeatureKey]
    
}
