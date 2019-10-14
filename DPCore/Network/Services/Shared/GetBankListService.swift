//
//  GetBankList.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class GetBankListService: Service {
    var requests: RequestBuilder {
        let url = MainEndPoint(env: .production, endpoint: "banks")
        return RequestBuilder(url: url.path!)
            .set(method: .get)
            .set(headers: ["ticket": "\(self.ticket)"])
            .set(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil)
    }
    private let ticket: String
    
    typealias responseType = BankListResponse
    
    var task: URLSessionTask?
    
    init(ticket: String) {
        self.ticket = ticket
    }
    
}
