//
//  BaseResponse.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

protocol BaseResponse: Decodable {
    var requestUUID: String? {get set}
    var result: ResponseResult {get set}
}

struct BaseResponseModel: BaseResponse {
    var requestUUID: String?
    var result: ResponseResult
    
}
