//
//  PinProtectionService.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/6/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

class PinProtectionService: Service {
    
    var task: URLSessionTask?
    
    typealias responseType = PinVerifyResponse
    
    let data: PinRequestModel
    
    private let ticket: String
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "users/login")
        return  RequestBuilder(url: path.path!)
            .set(headers: ["Content-Type": "application/json;charset=UTF-8"])
            .set(bodyParameters: data.dictionary, bodyEncoding: .jsonEncoding, urlParameters: nil)
            .set(headers: ["ticket": self.ticket])
            .set(method: .post)
        
    }
    
    init(ticket: String, data: PinRequestModel) {
        self.data = data
        self.ticket = ticket
    }
    
}
