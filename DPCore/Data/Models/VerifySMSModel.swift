//
//  VerifySMSModel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct VerifySMSModel: GenericModelProtocol, Encodable {
    var requestUUID: String
    
    var device: DeviceModel
    
    var deviceToken: String
    
}
