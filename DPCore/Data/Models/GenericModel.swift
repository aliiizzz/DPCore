//
//  UserDevice.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

protocol GenericModelProtocol: Encodable {
    var requestUUID: String { get set }
    var device: DeviceModel { get set }
    
}

struct GenericModel: GenericModelProtocol, Encodable {
    var device: DeviceModel
    var requestUUID: String
    
    init() {
        self.device = DeviceModel()
        self.requestUUID = UUID().uuidString
    }
    
}
