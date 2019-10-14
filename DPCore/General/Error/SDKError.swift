//
//  SDKError.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-13.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

public struct SDKError: APIError, InternalError, LocalizedError, CustomNSError {
    public var message: String
    public var code: Int
    
    public var errorDescription: String {
        return self.message
    }
    
    public var localizedDescription: String {
        return self.errorDescription
        
    }
    
    public static var errorDomain: String {
        return "DPCoreErrorDomain"
    }
    
    public var errorCode: Int {
        return self.code
    }
    
    public var errorUserInfo: [String: Any] {
        return [NSLocalizedDescriptionKey: self.localizedDescription]
    }

}
