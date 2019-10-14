//
//  PinResponse.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/6/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

struct PinVerifyResponse: BaseResponse {
    var requestUUID: String?
    var result: ResponseResult
}
