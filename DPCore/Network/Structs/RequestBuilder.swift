//
//  RequestBuilder.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal final class RequestBuilder: URLRequestConvertible {
    var request: URLRequest
    
    init(url: URL) {
        request = URLRequest(url: url)
        defaultInit()
    }
    
    fileprivate func defaultInit() {
        set(method: .get)
        set(timeInterval: .default)
    }
    
    @discardableResult
    func set(url: URL) -> RequestBuilder {
        request.url = url
        return self
    }
    
    @discardableResult
    func set(method: HTTPMethod) -> RequestBuilder {
        request.httpMethod = method.rawValue
        return self
    }
    
    @discardableResult
    func set(timeInterval: RequestTimeoutInterval) -> RequestBuilder {
        request.timeoutInterval = timeInterval.rawValue
        return self
    }
    
    @discardableResult
    func set(headers: HTTPHeaders) -> RequestBuilder {
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return self
    }
    
    @discardableResult
    func set(body: Data) -> RequestBuilder {
        request.httpBody = body
        return self
    }
    
    func set(bodyParameters: Parameters?,
             bodyEncoding: ParameterEncoding,
             urlParameters: Parameters?) -> RequestBuilder {
        do {
            try bodyEncoding.encode(urlRequest: &self.request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
            return self
        }
        catch {
           fatalError()
        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        return request
    }
}
