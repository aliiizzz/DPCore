//
//  NetworkError.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal enum NetworkResponse: Error {
    case success
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case mappingError
}

extension NetworkResponse {
    
    var errorDescription: String {
        switch self {
        case .success:
            return "Success"
        case .authenticationError:
            return "Authentication Error"
        case .failed:
            return "Failed"
        case .noData:
            return "No Data Found In Response"
        case .badRequest:
            return "Server Response Error"
        case .outdated:
            return "Outdated"
        case .unableToDecode, .mappingError:
            return "mapping error"
        default:
            return "Unknown"
        }
    }
    
    var localizedDescription: String {
        return self.errorDescription
    }
    
    var sdkError: SDKError {
        return SDKError(message: self.localizedDescription, code: SDKErrorCode.internal.rawValue)
    }
}

internal enum Result<Error> {
    case success
    case failure(Error)
    case failureWithData(Error, Decodable)
}

internal extension URLError {
    
    var persianLocalizationError: String {
        switch code {
        case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
            return "مشکل در برقراری ارتباط با سرور"
        default:
            return "اشکال در اتصال به اینترنت"
        }
    }
}
