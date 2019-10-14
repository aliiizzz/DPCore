//
//  UIApplication+TopController.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-28.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

extension UIApplication {
    static var topViewController: UIViewController? {
        return recursiveTopViewController()
    }
    
    private class func recursiveTopViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return recursiveTopViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return recursiveTopViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return recursiveTopViewController(presented)
        }
        return base
    }
}
