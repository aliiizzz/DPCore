//
//  ValidateOTPService.swift
//  DPCore
//
//  Created by Amir Roudsari on 7/2/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation
class ValidateOTPService: Service {
    
    var requests: RequestBuilder {
        let path = MainEndPoint(env: .production, endpoint: "users/otp/verify")
        return RequestBuilder(url: path.path!)
            .set(method: .post)
            .set(headers: ["ticket": self.ticket])
            .set(bodyParameters: data.dictionary,
                 bodyEncoding: .jsonEncoding,
                 urlParameters: nil)
        
    }
    
    private let ticket: String
    private var data: OtpValidationModel?
    typealias responseType = OtpValidationResponse
    
    var task: URLSessionTask?
    
    init(ticket: String) {
        self.ticket = ticket
    }
    
    func set(code data: OtpValidationModel) {
        self.data = data
    }
}
