//
//  PaymentViewController+DatePicker.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-15.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit
import Foundation

extension PaymentViewController {
    
    func configureTextFieldForDataPicker(textField: UITextField, datePicker: MonthYearPickerView) {
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
       
        let cancelBtn = self.cancelButton
        cancelBtn.setTitleTextAttributes([.font: UIFont(name: "IRANYekan", size: 14.0)!,
                                          .foregroundColor: SDKColors.secondaryLight], for: [.normal])
        cancelBtn.setTitleTextAttributes([.font: UIFont(name: "IRANYekan", size: 14.0)!,
                                          .foregroundColor: SDKColors.secondaryLight], for: [.highlighted])
        
        cancelBtn.setTitleTextAttributes([.font: UIFont(name: "IRANYekan", size: 14.0)!,
                                          .foregroundColor: SDKColors.secondaryLight], for: [.focused])
        
        let doneBtn = self.doneButton
        doneBtn.setTitleTextAttributes([.font: UIFont(name: "IRANYekan", size: 14.0)!], for: [.normal])
        doneBtn.setTitleTextAttributes([.font: UIFont(name: "IRANYekan", size: 14.0)!], for: [.highlighted])
        doneBtn.setTitleTextAttributes([.font: UIFont(name: "IRANYekan", size: 14.0)!], for: [.focused])
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        // revert items when host application language direction is LeftToRight
        var items: [UIBarButtonItem] = [self.cancelButton, flexibleSpace, self.doneButton].reversed()
        
        // check curernt host application language is rightToLeft
        // then reverted items 
        if let window = UIApplication.shared.keyWindow, UIView.userInterfaceLayoutDirection(for: window.semanticContentAttribute) == .rightToLeft {
            items = items.reversed()
        }
        
        toolbar.setItems(items, animated: true)
        toolbar.isUserInteractionEnabled = true
        
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
        
        textField.addTarget(self, action: #selector(datePickerDidChangeEditing(textField:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(datePickerDidChangeEditing(textField:)), for: .editingDidEnd)
        
        datePicker.semanticContentAttribute = .forceRightToLeft
        datePicker.setNeedsLayout()
        datePicker.setNeedsDisplay()
        datePicker.layoutIfNeeded()
        
    }
    
    func showDimView(_ parent: UIView, show: Bool = false) {
        
        var view = parent.viewWithTag(1051)
        
        if show {
            if view == nil {
                view = UIView()
                view!.tag = 1051
                view!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            }
            
            if view?.superview != nil {
                view!.removeFromSuperview()
            }
            
            view?.alpha = 0
            parent.addSubview(view!)
            view?.pinToSuperviewEdges()
            
        }
        
        let toAlpha: CGFloat = show ? 1.0 : 0.0
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: [.allowUserInteraction, .beginFromCurrentState],
                       animations: {
                        view?.alpha = CGFloat(toAlpha)
        }) { (finished) in
            guard finished, !show else { return }
            view?.removeFromSuperview()
        }
        
    }
    
    @objc func datePickerDidChangeEditing(textField: UITextField) {
        guard let parent = self.parent else { return }
        
        showDimView(parent.view, show: textField.isEditing)
        
    }
    
    @objc func getDate() {
        self.view.viewWithTag(1051)?.removeFromSuperview()
        self.dismissKeyboard()
    }
    
    @objc func closeDatePicker() {
        self.view.viewWithTag(1051)?.removeFromSuperview()
        self.dismissKeyboard()
    }
}
