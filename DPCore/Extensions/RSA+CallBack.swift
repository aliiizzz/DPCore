//
//  String+Encryption.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-14.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

typealias encryptedStrCallback = (String, Error?) -> Void

extension String {
    func encrypt(_ fileName: String, callback: @escaping encryptedStrCallback ) {
        let service = GetCertFileService(ticket: GlobalInput.ticket, cert: fileName)
        service.run().subscribe(onNext: {
            let str = String(data: $0, encoding: .utf8) as! String
            self.onSuccess(str, callback: callback)
        }, onError: {
            callback("", $0)
        })
    }
    fileprivate  func onSuccess(_ data: String, callback:@escaping encryptedStrCallback) {
        let val = RSA(self, data)
        callback(val!, nil)
        
    }
    
    fileprivate func onError(_ err: Error, callback:@escaping encryptedStrCallback) {
        
    }
}
