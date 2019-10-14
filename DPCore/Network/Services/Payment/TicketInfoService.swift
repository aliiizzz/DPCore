//
//  TicketInfoService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class TicketInfoService: Service {
    var requests: RequestBuilder {
        return RequestBuilder(url: url.appendingPathComponent(ticket))
            .set(method: .get)
            .set(headers: ["ticket": self.ticket])
        
    }
    
    private let ticket: String
    private let url: URL
    typealias responseType = TicketInfoResponse
    
    var task: URLSessionTask?
    
    init(ticket: String, ticketInfoURL: URL) {
        self.ticket = ticket
        self.url = ticketInfoURL
    }
}
