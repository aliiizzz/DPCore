//
//  UIViewController+PrevNextToolbar.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

extension UIViewController {
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(title: "بعدی", style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                }
                else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(title: "قبلی", style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                }
                else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self.view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
}
