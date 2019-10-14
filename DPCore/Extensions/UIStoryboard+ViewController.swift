//
//  UIStoryboard+ViewController.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-27.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

private let storyboard = UIStoryboard(name: "Payment", bundle: Bundle(for: DPCore.self))

extension UIStoryboard {
    
    class func viewController<T: UIViewController>(identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func viewController<T: UIViewController>(identifier: String) -> T {
        return self.instantiateViewController(withIdentifier: identifier) as! T
    }
}
