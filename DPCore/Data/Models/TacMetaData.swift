//
//  TACModels.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/1/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

internal enum TacGatewayType: Int, Codable {
    case ipg = 0
    case dpg = 1
    case ussd = 2
    case wallet = 3
}

typealias UserDetail = TacMetaData.UserDetail

internal struct TacMetaData: Decodable {
    
    let infoURL: URL?
    let payURL: URL?
    let gateways: [TacGatewayType]?
    private(set) var features: [ProtectedFeatureKey: FeatureModel]
    private(set) var userDetail: UserDetail?
    
    enum CodingKeys: String, CodingKey {
        case infoURL = "infoUrl"
        case payURL = "payUrl"
        case gateways = "gateways"
        case features = "features"
        case userDetail = "userDetail"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        infoURL = try container.decodeIfPresent(URL.self, forKey: .infoURL)
        payURL = try container.decodeIfPresent(URL.self, forKey: .payURL)
        
        self.gateways = try container.decodeIfPresent([TacGatewayType].self, forKey: .gateways)
        
        self.userDetail = try container.decodeIfPresent(UserDetail.self, forKey: .userDetail)
        
        let featureDic = try container.decodeIfPresent([String: FeatureModel].self,
                                                       forKey: .features)
        
        var mapped = [ProtectedFeatureKey: FeatureModel]()
        
        if let featureDic = featureDic {
            for (key, value) in featureDic {
                mapped[ProtectedFeatureKey.init(rawValue: key) ?? .none] = value
            }
        }
        
        self.features = mapped
        
    }
    
    mutating func update(features: [ProtectedFeatureKey: FeatureModel]) {
        self.features = features
    }
    
    mutating func update(userDetail: UserDetail?) {
        self.userDetail = userDetail
    }
    
}

extension TacMetaData {
    
    struct UserDetail: Codable {
        
        let userId: String
        private let cellNumber: String
        private let active: Bool
        
        var isActive: Bool {
            return active
        }
        
        var mobileNumber: String {
            return cellNumber
        }
        
    }
}
