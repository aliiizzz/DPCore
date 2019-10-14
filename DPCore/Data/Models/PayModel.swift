//
//  PayModel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-14.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct PayModel: Encodable {
    
    enum PayType: String, Encodable {
        case card = "card"
        case wallet = "wallet"
        case ipg = "ipg"
        
        func encode(to encoder: Encoder) throws {
            
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
            
        }
        
    }
    
    var requestUUID: String
    let ticket: String
    let source: Source?
    let encryptedPinDto: String?
    let certFile: String?
    var type: PayType = .card
    
    init(requestUUID: String? = nil,
         ticket: String, source: Source? = nil,
         encryptedPinDto: String? = nil,
         certFile: String? = nil,
         type: PayType = .card) {
        
        self.requestUUID = requestUUID ?? UUID().uuidString
        self.ticket = ticket
        self.source = source
        self.encryptedPinDto = encryptedPinDto
        self.certFile = certFile
        self.type = type
        
    }
    
}
