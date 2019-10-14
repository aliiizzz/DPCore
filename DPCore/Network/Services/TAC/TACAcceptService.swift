//
//  TACAcceptService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class TACAcceptService: Service {
   
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production,
                                endpoint: "users/in-app/tac/accept")
        return RequestBuilder(url: path.path!)
            .set(method: .post)
            .set(headers: ["ticket": self.ticket])
            .set(headers: ["Content-Type": "application/json;charset=UTF-8"])
            .set(bodyParameters: data.dictionary,
                 bodyEncoding: .jsonEncoding,
                 urlParameters: nil)
        
    }
    
    private let ticket: String
    private var data: PayModel?
    let tacURL: URL
    
    typealias responseType = TACResponse
    
    var task: URLSessionTask?
    
    init(ticket: String, tacURL: URL) {
        
        self.ticket = ticket
        self.tacURL = tacURL
    }
    
    func set(payInfo data: PayModel) {
        self.data = data
    }
   
}
