//
//  PayResponse.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct PayResponse: BaseResponse {
    var requestUUID: String? = ""
    
    var result: ResponseResult
    
    let payModel: PayResponseModel?
    let payInfo: String?
    
    enum CodingKeys: String, CodingKey {
        case requestUUID = "requestUUID"
        case result = "result"
        case payInfo = "payInfo"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.requestUUID = try container.decodeIfPresent(String.self, forKey: .requestUUID)
        self.result = try container.decode(ResponseResult.self, forKey: .result)
        self.payInfo = try container.decodeIfPresent(String.self, forKey: .payInfo)
        
        self.payModel = (try? PayResponseModel(from: decoder)) ?? nil
        
    }
    
}

struct PayResponseModel: Decodable {
    
    let paymentResult: Int?
    let status: String
    let color: Int
    let imageId: String?
    let title: String
    let amount: Int
    var message: String?
    var trackingCode: String?
    let activityInfo: [String: [String: String?]]
    
}
