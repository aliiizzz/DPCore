//
//  Presentable.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-23.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit

protocol Presentable: AnyObject {
    
    var identifier: UUID { get }
    
    var viewController: UIViewController? { get }
    
    func toPresent() -> UIViewController?
    
}

extension Presentable {
    
    var identifier: UUID {
        fatalError("instance and return identifier")
    }
}
