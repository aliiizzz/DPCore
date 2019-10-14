//
//  AnyService.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal protocol AnyService: class {
    var task: URLSessionTask? { get set }
    func request(_ route: RequestBuilder, completion: @escaping Completion)
    func cancel()
}

private let session = URLSession(configuration: configuration)
extension AnyService {
    
    func request(_ route: RequestBuilder, completion: @escaping Completion) {
        
        do {
            route.set(headers: ["Agent": Device.osName,
                                "Digipay-Version": SDKSetting.sdkHeaderVersion])
            
            let routes = try route.asURLRequest()
            NetworkLogger.log(request: routes)
            
            task = session.dataTask(with: routes, completionHandler: { data, response, error in
                completion(data, response, error)
                //session.finishTasksAndInvalidate()
            })
        }
        catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
}
