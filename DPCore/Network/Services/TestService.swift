//
//  TestService.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
struct TestData: Decodable {
    var args: [String: String]?
    var headers: [String: String]
    var origin: String
    var url: String
}

class TestService: Service {
    var task: URLSessionTask?
    
    typealias responseType = TestData
    
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "/get")
        return RequestBuilder(url: path.path!).set(method: .get)
    }
    
    init() {
        self.run()
    }
}
