//
//  URLRequestConvertible.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

/// Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
internal protocol URLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    /// The URL request.
    var urlRequest: URLRequest? { return try? asURLRequest() }
}
