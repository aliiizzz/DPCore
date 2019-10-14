//
//  OTPResponse.swift
//  DPCore
//
//  Created by Amir Roudsari on 7/3/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

struct OtpRequestResponse: BaseResponse {
    var requestUUID: String?
    var result: ResponseResult
}

struct OtpValidationResponse: BaseResponse {
    var requestUUID: String?
    var result: ResponseResult
}
