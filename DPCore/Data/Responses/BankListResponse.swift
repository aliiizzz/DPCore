//
//  BankListResponse.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-12.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct BankListResponse: BaseResponse {
    var requestUUID: String?
    
    var result: ResponseResult
    let banks: [BankModel]
    
}

struct BankModel: Decodable {
    let name: String
    let code: String
    let cardPrefixes: [String]
    let uid: String
    let imageId: String
    let xferCert: String?
    let profileCert: String?
    let colorRange: [Int]
    
}
