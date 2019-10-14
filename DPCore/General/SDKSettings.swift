//
//  SDKSettings.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct SDKSetting {
    static let API_VERSION = "1"
    static let sdkHeaderVersion = "2019-09-01"
    static let PRODUCTION_URL: String = {
        #if DEBUG
        return "https://dev.mydigipay.info"
        #elseif Staging
        return "https://uat.mydigipay.com"
        #elseif SMOKYRELEASE
        return "https://smokyapi.mydigipay.com"
        #elseif RELEASE
        return "https://api.mydigipay.com"
        #endif
    }()
    
    static let MID_URL = "digipay/api"
    
}
