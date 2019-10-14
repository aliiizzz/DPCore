//
//  GetCardListService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class GetCardListService: Service {
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "cards")
        return RequestBuilder(url: path.path!)
            .set(method: .get)
            .set(headers: ["ticket": self.ticket])
    }
    private let ticket: String
    typealias responseType = CardResponse
    
    var task: URLSessionTask?
    
    init(ticket: String) {
        self.ticket = ticket
    }
    
}
