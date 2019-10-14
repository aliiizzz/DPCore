//
//  UIViewController+PresentedViewController.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/24/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

extension UIViewController {
    
    /// find and return present view controller on top view controller
    ///
    /// - Parameter viewController: a object 
    /// - Returns: <#return value description#>
    func presentedViewController(`for` viewController: UIViewController) -> UIViewController? {
        
        guard let presentedVC = viewController.presentedViewController else {
            return viewController
        }
        
        return self.presentedViewController(for: presentedVC)
    }
    
    /// find and return a top presented view controller
    ///
    /// - Returns: A top `UIViewController` presented
    func topPresentedViewController() -> UIViewController {
        
        var presentedViewController: UIViewController = self
        
        if let presentedVC  = self.presentedViewController(for: self) {
            presentedViewController = presentedVC
        }
        
        return presentedViewController
    }
    
}
