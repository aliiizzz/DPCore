//
//  JSONParameterEncoding.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal struct JSONParameterEncoder: ParameterEncoder {
    
    static var `default`: JSONParameterEncoder { return JSONParameterEncoder() }
    /// Returns a `JSONEncoding` instance with `.prettyPrinted` writing options.
    static var prettyPrinted: JSONParameterEncoder { return JSONParameterEncoder(options: .prettyPrinted) }
    
    /// The options for writing the parameters as JSON data.
    let options: JSONSerialization.WritingOptions
    
    // MARK: Initialization
    
    /// Creates a `JSONEncoding` instance using the specified options.
    ///
    /// - parameter options: The options for writing the parameters as JSON data.
    ///
    /// - returns: The new `JSONEncoding` instance.
    init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }

}

extension JSONParameterEncoder {
     func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        catch {
            throw NetworkError.encodingFailed
        }
    }
}
