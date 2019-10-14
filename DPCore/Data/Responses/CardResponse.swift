//
//  CardResponse.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-12.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct CardResponse: BaseResponse {
    var requestUUID: String?
    var result: ResponseResult
    let cards: [Card]
}

struct Card: Decodable {
    let cardIndex: String
    let prefix: String
    let postfix: String
    let expireDate: String
    let bankName: String
    let colorRange: [Int]
    let imageId: String
    
}
