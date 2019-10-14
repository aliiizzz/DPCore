//
//  FeatureModel.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/1/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

internal struct FeatureModel: Codable {
   
    let title: String?
    let isProtected: ProtectionType
    let isEditable: Bool?
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case title
        case isProtected
        case isEditable = "editable"
        case url
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decodeIfPresent(String.self, forKey: .title)
        isProtected = try container.decodeIfPresent(ProtectionType.self, forKey: .isProtected) ?? .none
        isEditable = try container.decodeIfPresent(Bool.self, forKey: .isEditable)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        
    }
    
}

internal enum ProtectionType: Int, Codable {
    case none
    case pin
    case otp
    case inAppVerification
}

internal enum ProtectedFeatureKey: String, Codable {
    
    case none = ""
    case paymentWallet = "0"
    case paymentDPG = "1"
    case paymentIPG = "2"
    case settings = "50"
    case settingsPassword = "51"
    case LoginHome = "100"
    case SDKInfo = "150"
}

extension ProtectedFeatureKey: CustomStringConvertible {
    var description: String {
        switch self {
        case .none: return "None"
        case .paymentWallet: return "Wallet"
        case .paymentDPG: return "DPG"
        case .paymentIPG: return "IPG"
        case .settings: return "Settings"
        case .settingsPassword: return "SettingsPassword"
        case .LoginHome: return "LoginHome"
        case .SDKInfo: return "SDKInfo"
        }
    }
}

extension ProtectedFeatureKey: Equatable {
    
    static func ==(lhs: ProtectedFeatureKey, rhs: ProtectedFeatureKey) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.paymentWallet, .paymentWallet):
            return true
        case (.paymentDPG, .paymentDPG):
            return true
        case (.paymentIPG, .paymentIPG):
            return true
        case (.settings, .settings):
            return true
        case (.settingsPassword, .settingsPassword):
            return true
        case (.LoginHome, .LoginHome):
            return true
        case (.SDKInfo, .SDKInfo):
            return true
        
        default:
            return false
        }
    }
}
