//
//  RSA.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-11.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

func RSA(_ message: String, _ key: String) -> String? {
    let cleanKey = key
        .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
        .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
    do {
        let publicKey = try PublicKey(base64Encoded: cleanKey)
        let clearMessage = try ClearMessage(string: message, using: .utf8)
        let encrypted = try clearMessage.encrypted(with: publicKey, padding: .PKCS1)
        return encrypted.base64String
    }
    catch {
        return nil
    }
}
