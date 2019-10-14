//
//  Disposable.swift
//  DPCore
//
//  Created by Farshad Mousalou on 6/29/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

/// Array of `Disposable`
public typealias Disposal = [Disposable]

/// Disposable class
public final class Disposable {
    
    private let dispose: () -> Void
    
    init(_ dispose: @escaping () -> Void) {
        self.dispose = dispose
    }
    
    deinit {
        dispose()
    }
    
    public func add(to disposal: inout Disposal) {
        disposal.append(self)
    }
}
