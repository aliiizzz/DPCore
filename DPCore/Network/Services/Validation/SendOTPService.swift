//
//  SendOTPService.swift
//  DPCore
//
//  Created by Amir Roudsari on 7/2/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

class SendOTPService: Service {
    
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "users/otp")
        return RequestBuilder(url: path.path!)
            .set(method: .post)
            .set(headers: ["ticket": self.ticket])
            .set(headers: ["Content-Type": "application/json;charset=UTF-8"])
        
    }
    private let ticket: String
    private var data: OTPSendModel?
    typealias responseType = OtpRequestResponse
    
    var task: URLSessionTask?
    
    init(ticket: String) {
        self.ticket = ticket
    }
    
    func set(payInfo data: OTPSendModel) {
        self.data = data
    }
}
