//
//  GlobalInput.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-06.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct GlobalInput {
    static var ticket: String = ""
    static var tacUrl: String = ""
    static var metaData: TacMetaData?
    static var status: responseTypes! = {_, _, _ in }
}

internal struct GlobalResponse {
    let status: DPStatus
    let data: [String: Any]
    let error: Error?
    
    static func buildResponse(status: DPStatus,
                              data: [String: String],
                              error : (code: SDKErrorCode, message: String)?) -> GlobalResponse {
        
        var responseError: SDKError?
        
        if let error = error {
            responseError = SDKError(message: error.message,
                                     code: error.code.rawValue)
        }
        
        return GlobalResponse(status: status,
                              data: data,
                              error: responseError)
        
    }
    
}

typealias SDKResponse = GlobalResponse
