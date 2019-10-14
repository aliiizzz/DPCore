//
//  TopUpPayResponse.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct TopUpPayResponse: BaseResponse {
    var requestUUID: String? = ""
    
    var result: ResponseResult
    
    let topUpInfo: TopUpModel
    
    let rrn: String?
    let source: String?
    var message: String?
    
    let paymentResult: Int
    
}
