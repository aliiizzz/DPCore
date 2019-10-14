//
//  TopUpTicketInfoModel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct TopUpTicketInfoResponse: BaseResponse {
    var requestUUID: String?
    
    var result: ResponseResult
    
    let topUp: TopUpModel
    let certFile: String
    let pspCode: String
    let images: [String]
    let walletBalance: Int?
}
