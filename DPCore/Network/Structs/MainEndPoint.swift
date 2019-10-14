//
//  MainEndPoint.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal struct MainEndPoint: EndPointType {
    var path: URL? {
        return URL(string: "\(self.baseURL)/\(SDKSetting.MID_URL)/\(self.endpoint)")
    }
    private let env: NetworkEnvironment
    
    private let endpoint: String
    var headers: HTTPHeaders? {
        return ["Content-Type": "Application/JSON"]
    }
    
    var baseURL: String {
        switch env {
        case .production :
            return SDKSetting.PRODUCTION_URL
        case .qa:
            return ""
        case .staging:
            return ""
        }
    }
    
    init(env: NetworkEnvironment, endpoint: String) {
        self.env = env
        self.endpoint = endpoint
    }
    
}
