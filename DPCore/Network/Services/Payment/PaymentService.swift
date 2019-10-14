//
//  PaymentService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class PaymentService: Service {
    
    var requests: RequestBuilder {
        return RequestBuilder(url: payURL)
            .set(method: .post)
            .set(headers: ["ticket": self.ticket])
            .set(headers: ["Content-Type": "application/json;charset=UTF-8"])
            .set(bodyParameters: data.dictionary,
                bodyEncoding: .jsonEncoding,
                urlParameters: nil)
    }
    
    private let ticket: String
    private var data: PayModel?
    let payURL: URL
    
    typealias responseType = PayResponse
    
    var task: URLSessionTask?
    
    init(ticket: String, payURL: URL) {
        
        self.ticket = ticket
        self.payURL = payURL

    }
    
    func set(payInfo data: PayModel) {
        self.data = data
    }
}
