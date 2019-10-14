//
//  Service.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

// TODO: to be more generic I should Add decoding type as Associated type
// then replace JSONDecoder with the type
internal protocol Service: AnyService {
    associatedtype responseType: Decodable
    var requests: RequestBuilder { get }
}

extension Service {
    
    func run(ignoreStatusCodes statusCodes: Set<Int>? = nil) -> Future<responseType> {
        return Future {[weak self] completion in
            
            guard let `self` = self else { return }
            
            self.request(self.requests) { data, response, error in
                
                guard error == nil else {
                    
                    completion(.failure(error!))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response,
                                                            data: data,
                                                            ignoreStatusCodes: statusCodes)
                    switch result {
                    case .success:
                        guard let responseData = data, responseData.count > 0 else {
                            completion(.failure(NetworkResponse.noData))
                            return
                        }
                        do {
                            if (response.allHeaderFields["Content-Type"] as? String)?.contains("json") == true {
                                printDebug("------------- response ----------------")
                                printDebug("Data => \(String(data: self.convertToUTF8(data: responseData, response: response), encoding: .utf8) ?? "empty Data")")
                                printDebug("------------- response ----------------")
                            }
                            if responseType.self is Data.Type, let data = responseData as? responseType {
                                completion(.success(data))
                                return
                            }
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .millisecondsSince1970
                            let responseDecoded = try decoder.decode(responseType.self, from: responseData)
                            completion( .success(responseDecoded))
                        }
                        catch {
                            printDebug(error)
                            completion(.failure( NetworkResponse.unableToDecode))
                        }
                    case .failure(let networkFailureError):
                        completion(.failure(networkFailureError))
                    case .failureWithData(let error, let data):
                        completion(.failureWithData(error, data))
                    }
                }
            }
        }
        
    }
    
    // TODO: Move Error Handler from app to here
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse,
                                           data: Data? = nil,
                                           ignoreStatusCodes: Set<Int>?) -> Result<Error> {
        switch response.statusCode {
        case let code where ignoreStatusCodes?.contains(code) == true: return .success
        case 200: return .success
        case 401...421: return .failure(NetworkResponse.authenticationError)
        case 422:
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                
                let responseDecoded = try decoder.decode(responseType.self, from: data!)
                let stat = responseDecoded as! BaseResponse
                let error = SDKError(message: stat.result.message, code: SDKErrorCode.internal.rawValue)
                printDebug("decoded Error: \(responseDecoded)")
                printDebug("decoded Error Message: \(stat)")
                return .failureWithData(error, responseDecoded)
            }
            catch {
                printDebug("decoded Error Message: \(error)")
                return .failure(NetworkResponse.unableToDecode)
            }
        case 423...500: return .failure(NetworkResponse.unableToDecode)
        case 501...599: return .failure(NetworkResponse.badRequest)
        case 600: return .failure(NetworkResponse.outdated)
        default: return .failure(NetworkResponse.failed)
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - response: <#response description#>
    /// - Returns: <#return value description#>
    fileprivate func convertToUTF8(data: Data, response: URLResponse?) -> Data {
        
        var convertedData = data
        
        var convertedEncoding: String.Encoding?
        
        if let encodingName = response?.textEncodingName as CFString!, convertedEncoding == nil {
            convertedEncoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(
                CFStringConvertIANACharSetNameToEncoding(encodingName))
            )
        }
        
        let actualEncoding = convertedEncoding ?? String.Encoding.isoLatin1
        
        let responseString = String(data: convertedData, encoding: actualEncoding)
        
        convertedData = responseString!.data(using: .utf8)!
        return convertedData
    }
    
}
