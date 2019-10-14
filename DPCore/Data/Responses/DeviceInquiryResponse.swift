//
//  DeviceInquiryResponse.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct DeviceInquiryResponse: BaseResponse, Decodable {
    var requestUUID: String?
    
    var result: ResponseResult
    
    var shouldVerify: Bool
}
