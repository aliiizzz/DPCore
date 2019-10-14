//
//  GetCertFileService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class GetCertFileService: Service {
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "certs/\(self.certName)")
        return RequestBuilder(url: path.path!)
            .set(method: .get)
            .set(headers: ["ticket": self.ticket])
        
    }
    private let ticket: String
    private let certName: String
    typealias responseType = Data
    
    var task: URLSessionTask?
    init(ticket: String, cert: String) {

        self.ticket = ticket
        self.certName = cert
    }
}
