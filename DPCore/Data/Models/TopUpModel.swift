//
//  TopUpModel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct TopUpModel: Decodable {
    let feeCharge: Int
    let name: String
    let expirationDate: Date
    let creationDate: Date
    let targetedCellNumber: String
    let productCode: String
    let operatorId: Int
    let trackingCode: String
    let chargePackage: ChargePackage?
    let internetPackage: InternetPackage?
    let chargeType: String
    let imageId: String
    let type: Int
    let description: String
    let topUpDescription: String?
    let ownerSide: Int
    let status: Int
    
}

struct ChargePackage: Decodable {
    let amount: Int
}

struct InternetPackage: Codable {
    
    let bundleID: String
    let amount: Int?
    let description: String
    let durationDescription: String?
    let duration: Int?
    
    enum CodingKeys: String, CodingKey {
        case bundleID = "bundleId"
        case amount,
        description
        case duration
        case durationDescription
    }
}
