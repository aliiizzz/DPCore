//
//  BillPaymentService.swift
//  DPCore
//
//  Created by Farshad Mousalou on 12/23/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class BillPaymentService: Service {
    
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "bills/pay")
        return RequestBuilder(url: path.path!)
            .set(method: .post)
            .set(headers: ["ticket": self.ticket])
            .set(bodyParameters: data.dictionary,
                 bodyEncoding: .jsonEncoding,
                 urlParameters: nil)
        
    }
    private let ticket: String
    private var data: PayModel?
    typealias responseType = BillPayResponse
    
    var task: URLSessionTask?
    
    init(ticket: String) {
        self.ticket = ticket
    }
    
    func set(payInfo data: PayModel) {
        self.data = data
    }
}
