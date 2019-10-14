//
//  TACService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class TACService: Service {
    var task: URLSessionTask?
    
    typealias responseType = TACResponse
    let data: GenericModel
    private let ticket: String
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "users/in-app/tac")
        return  RequestBuilder(url: path.path!)
            .set(bodyParameters: data.dictionary, bodyEncoding: .jsonEncoding, urlParameters: nil)
            .set(headers: ["ticket": self.ticket])
            .set(method: .post)
       
    }
    
    init(ticket: String) {
        self.data = GenericModel()
        self.ticket = ticket
    }
}
