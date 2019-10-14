//
//  GetFileService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class GetFileService: Service {
    
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "files/\(self.fileId)")
        return RequestBuilder(url: path.path!)
            .set(method: .get)
            .set(headers: ["ticket": self.ticket])
        
    }
    private let ticket: String
    private let fileId: String
    typealias responseType = Data
    
    var task: URLSessionTask?
    
    init(ticket: String, fileId: String) {
        self.ticket = ticket
        self.fileId = fileId
    }
}
