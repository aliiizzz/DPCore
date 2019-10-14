//
//  TopUpTicketInfoService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class TopUpTicketInfoService: Service {
    
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "top-ups/ticket/\(self.ticket)")
        return RequestBuilder(url: path.path!)
            .set(method: .get)
            .set(headers: ["ticket": self.ticket])
        
    }
    private let ticket: String
    
    typealias responseType = TopUpTicketInfoResponse
    
    var task: URLSessionTask?
    
    init(ticket: String) {
        self.ticket = ticket
    }
}
