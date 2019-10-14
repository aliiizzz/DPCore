//
//  BillResponse.swift
//  DPCore
//
//  Created by Farshad Mousalou on 12/23/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct BillInfoResponse: BaseResponse {
    
    var requestUUID: String?
    var result: ResponseResult
    
    let certFile: String
    let pspCode: String
    let walletBalance: Int?
    let images: [String]
    let billInfo: BillModel
    
}

struct BillPayResponse: BaseResponse {
    
    var requestUUID: String?
    
    var result: ResponseResult
    
    let rrn: String?
    let source: String?
    let message: String?
    
    let paymentResult: Int
    let billInfo: BillModel
    
}
