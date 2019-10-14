//
//  Observable.swift
//  DPCore
//
//  Created by Farshad Mousalou on 6/29/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

/// Generic Obserable Class
final class Observable<Type> {
    
    typealias Observer = (_ newValue: Type, _ oldValue: Type?) -> Void
    private var observers: [UUID: Observer] = [:]
    
    private let lock = NSRecursiveLock()
    
    private var _value: Type {
        didSet {
            
            // fire all observer when newValue has been setted
            guard let queue = queue else {
                self.onNext(with: oldValue)
                return 
            }
            
            queue.async {[weak self] in
                self?.onNext(with: oldValue)
            }
            
        }
        
    }
    
    var value: Type {
        get {
            self.lock.lock(); defer { self.lock.unlock() }
            return _value
        }
        set {
            lock.lock()
            _value = newValue
            lock.unlock()
        }
    }
    
    private var queue: DispatchQueue?
    private var shouldSkipFirst: Bool
    
    deinit {
        // cleaup observer from strong reference
        removeAllObservers()
    }
    
    /// Init Designed for Observer Class
    ///
    /// - Parameter value: a value of Generic `Type`
    init(_ value: Type, shouldSkipFirst: Bool = false) {
        
        lock.lock()
        _value = value
        self.shouldSkipFirst = shouldSkipFirst
        lock.unlock()
    }
    
    /// observer on specific queue
    ///
    /// - Parameter queue: callback queue, used when a new value is set
    /// - Returns: Observable<Type> object for observe
    func observer(on queue: DispatchQueue? = nil) -> Observable<Type> {
        self.queue = queue
        return self
    }
    /// skip first emit in observable
    ///
    /// - Returns: Observable<Type> object for observe
    func skipFirst() ->  Observable<Type> {
        self.shouldSkipFirst = true
        return self
    }
    
    /// observe and call back when a new value set
    ///
    /// - Parameter observer: callback closure, called when a new value is set
    /// - Returns: Disposable Object for dispose
    @discardableResult
    func observe(_ observer : @escaping Observer) -> Disposable {
        
        let id = UUID()
        observers[id] = observer
        
        if shouldSkipFirst == false {
            observer(value, nil)
        }
        
        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
        }
        
        return disposable
        
    }
    
    /// cleanup all observers
    func removeAllObservers() {
        observers.removeAll()
    }
    
    // MARK: - Private Methods
    private func onNext(with oldValue: Type?) {
        observers.values.forEach { (observer) in
            observer(_value, oldValue)
        }
    }
    
}
