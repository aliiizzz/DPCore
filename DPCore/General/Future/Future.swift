//
//  Future.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-03.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

enum FutureResult<T> {
    case success(T)
    case failure(Error)
    case failureWithData(Error, Decodable)
}

struct Future<T> {
    
    typealias ResultType = FutureResult<T>
    
    private let operation: ( @escaping (ResultType) -> Void) -> Void
    
    private var queue: DispatchQueue?
    
    init(result: ResultType) {
        self.init(operation: { completion in
            completion(result)
        })
    }
    
    init(value: T) {
        self.init(result: .success(value))
    }
    
    init(error: Error) {
        self.init(result: .failure(error))
    }
    
    init(operation: @escaping ( @escaping (ResultType) -> Void) -> Void) {
        self.operation = operation
    }
    
    fileprivate func then(_ completion: @escaping (ResultType) -> Void) {
        self.operation { result in
            completion(result)
        }
    }
    
    func subscribeOn(queue: DispatchQueue) -> Future<T> {
        var newValue = Future(operation: operation)
        newValue.queue = queue
        return newValue
    }
    
    func subscribe(onNext: @escaping (T) -> Void = { _ in },
                   onError: @escaping (Error) -> Void = { _ in },
                   onErrorWithData: @escaping ((Error, Decodable) -> Void) = {_, _ in}) {
        
        self.then { result in
            
            let block = {
                switch result {
                case .success(let value): onNext(value)
                case .failure(let error): onError(error)
                case .failureWithData(let error, let data): onErrorWithData(error, data)
                }
            }
            
            guard let queue = self.queue else {
                block()
                return
            }
            
            queue.async(execute: block)
            
        }
        
    }
}

extension Future {
    func map<U>(_ f: @escaping (T) throws -> U) -> Future<U> {
        return Future<U>(operation: { completion in
            self.then { result in
                switch result {
                    
                case .success(let resultValue):
                    do {
                        let transformedValue = try f(resultValue)
                        completion(FutureResult.success(transformedValue))
                    }
                    catch let error {
                        completion(FutureResult.failure(error))
                    }
                    
                case .failure(let errorBox):
                    completion(FutureResult.failure(errorBox))
                    
                case .failureWithData(let error, let data):
                    completion(FutureResult.failureWithData(error, data))
                }
            }
        })
    }
    
    func flatMap<U>(_ f: @escaping (T) -> Future<U>) -> Future<U> {
        return Future<U>(operation: { completion in
            self.then { firstFutureResult in
                switch firstFutureResult {
                case .success(let value): f(value).then(completion)
                case .failure(let error): completion(FutureResult.failure(error))
                case .failureWithData(let error, let data): completion(FutureResult.failureWithData(error, data))
                }
            }
        })
    }
}
