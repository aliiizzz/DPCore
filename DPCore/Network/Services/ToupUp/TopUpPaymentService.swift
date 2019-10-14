//
//  TopUpPaymentService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class TopUpPaymentService: Service {
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "top-ups/pay")
        return RequestBuilder(url: path.path!)
            .set(method: .post)
            .set(headers: ["ticket": self.ticket])
            .set(bodyParameters: data.dictionary,
                bodyEncoding: .jsonEncoding,
                urlParameters: nil)
        
    }
    private let ticket: String
    private var data: PayModel?
    typealias responseType = TopUpPayResponse
    
    var task: URLSessionTask?
    
    init(ticket: String) {
        self.ticket = ticket
    }
    
    func set(payInfo data: PayModel) {
        self.data = data
    }
}
