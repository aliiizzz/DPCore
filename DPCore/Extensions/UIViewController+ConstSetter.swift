//
//  UIViewController+ConstSetter.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-28.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.gestureDismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func gestureDismissKeyboard() {
        view.endEditing(true)
    }
    
    internal func dismissKeyboard() {
         view.endEditing(true)
    }
    
    func enableInteraction() {
        
        if let parentVC = self.parent {
            parentVC.view.isUserInteractionEnabled = true
        }
        else {
            self.view.isUserInteractionEnabled = true
        }
        
//        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func disableInteraction() {
        
        if let parentVC = self.parent {
            parentVC.view.isUserInteractionEnabled = false
        }
        else {
            self.view.isUserInteractionEnabled = false
        }
        
//        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func constSetter(_ view: UIView, to parent: UIView, const: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.topAnchor.constraint(equalTo: view.topAnchor, constant: const).isActive = true
        parent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const).isActive = true
        parent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: const).isActive = true
        parent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: const).isActive = true
    }
}
