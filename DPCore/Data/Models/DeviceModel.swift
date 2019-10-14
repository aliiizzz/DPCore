//
//  DeviceModel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct DeviceModel: Encodable {
    var imei: String?
    var deviceId: String
    var deviceModel: String
    var deviceAPI: String
    var osVersion: String
    var osName: String
    var appVersion: String
    var displaySize: String
    var manufacure: String
    var brand: String
    
    init() {
        self.imei = Device.vendorIdString
        self.deviceId = Device.vendorIdString
        self.deviceModel = Device.modelName
        self.deviceAPI = SDKSetting.API_VERSION
        self.osVersion = Device.osVersion
        self.appVersion = Device.AppVersion
        self.osName = Device.osName
        self.displaySize = Device.CURRENT_SIZE
        self.manufacure = "Apple"
        self.brand = Device.TheCurrentDevice.model
    }
}
