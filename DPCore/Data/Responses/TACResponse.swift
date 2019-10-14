//
//  TACResponse.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct TACResponse: BaseResponse, Decodable {
    var requestUUID: String?
    var result: ResponseResult
    var shouldAcceptTac: Bool?
    var tacUrl: String?
    var mode: Int?
    var metaData: TacMetaData?
    
    enum CodingKeys: String, CodingKey {
        case requestUUID
        case shouldAcceptTac
        case result
        case tacUrl
        case mode
        case metaData
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        requestUUID = try container.decodeIfPresent(String.self, forKey: .requestUUID)
        result = try container.decode(ResponseResult.self, forKey: .result)
        
        shouldAcceptTac = try container.decodeIfPresent(Bool.self, forKey: .shouldAcceptTac)
        tacUrl = try container.decodeIfPresent(String.self, forKey: .tacUrl)
        
        mode = try container.decodeIfPresent(Int.self, forKey: .mode)
        
        metaData = try container.decodeIfPresent(TacMetaData.self, forKey: .metaData)
        
        let alternativeMetaData = try TacMetaData(from: decoder)
        
        if var metaData = metaData {
            
            metaData.update(features: alternativeMetaData.features)
            metaData.update(userDetail: alternativeMetaData.userDetail)
            
            self.metaData = metaData
        }
        else {
            self.metaData = alternativeMetaData
        }
        
    }
    
}
