//
//  NetworkLogger.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal struct NetworkLogger {
    static func log(request: URLRequest) {
        
        printDebug("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { printDebug("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        printDebug(logOutput)
    }
    
    static func log(response: URLResponse) {}
}
