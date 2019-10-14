//
//  BillTicketInfoService.swift
//  DPCore
//
//  Created by Farshad Mousalou on 12/23/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class BillTicketInfoService: Service {
    
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "bills/ticket/\(self.ticket)")
        return RequestBuilder(url: path.path!)
            .set(method: .get)
            .set(headers: ["ticket": self.ticket])
        
    }
    
    private let ticket: String
    
    typealias responseType = BillInfoResponse
    
    var task: URLSessionTask?
    
    init(ticket: String) {
        self.ticket = ticket
    }
}
