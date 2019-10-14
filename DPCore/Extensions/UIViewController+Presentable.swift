//
//  UIViewController+Presentable.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-31.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

extension UIViewController: Presentable {}

extension Presentable where Self: UIViewController {
    
    var viewController: UIViewController? {
        return self
    }
    
    func toPresent() -> UIViewController? {
        return self
    }
    
}

extension Presentable where Self: UINavigationController {
    
    var viewController: UIViewController? {
        return self
    }
    
    func toPresent() -> UIViewController? {
        return self
    }
    
}

extension Presentable where Self: UITabBarController {
    
    var viewController: UIViewController? {
        return self
    }
    
    func toPresent() -> UIViewController? {
        return self
    }
}
