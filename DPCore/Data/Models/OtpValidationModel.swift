//
//  OtpValidationModel.swift
//  DPCore
//
//  Created by Amir Roudsari on 7/3/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

struct OtpValidationModel: Encodable {
    
    let code: String
    let features: [ProtectedFeatureKey]
    
    enum CodingKeys: String, CodingKey {
        case code = "smsToken"
        case features = "features"
    }
}
