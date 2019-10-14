//
//  UIView+loadNib.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-12.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

internal extension UIView {
    internal static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

internal extension UIView {
    
    internal class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil: nibNameOrNil, type: self)
    }
    
    internal class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = fromNib(nibNameOrNil: nibNameOrNil, type: T.self)
        return v!
    }
    
    internal class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        }
        else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = String(describing: T.self)
        }
        
        let bundle = Bundle(for: T.self) ?? Bundle.main
        
        let nibViews = bundle.loadNibNamed(name, owner: nil, options: nil)
        
        nibViews?.forEach({ (v) in
            if let tog = v as? T {
                view = tog
            }
        })
        
        return view
    }
    
    internal class func nib(nibNameOrNil: String? = nil) -> UINib {
        
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        }
        else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = String(describing: self)
        }
        
        let nib = UINib(nibName: name, bundle: Bundle(for: self))
        
        return nib
    }
    
}
