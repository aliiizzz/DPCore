//
//  PaymentViewController+init.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-11-16.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit

extension PaymentViewController {
  
    func initView() {
        
        self.view.isMultipleTouchEnabled = false
        
        self.payButton.isEnabled = false
        
        // MARK: - : init date picker
        configureTextFieldForDataPicker(textField: expireDate.textField, datePicker: datePicker)
        self.datePicker.onDateSelected = getDates
        
        // MARK: - : init bank images
        self.bankImages.dataSource = self
        self.bankImages.delegate = self
        self.bankImages.register(BankImageCollectionViewCell.nib(), forCellWithReuseIdentifier: "ImageCell")

        self.ipgBankImages.register(BankImageCollectionViewCell.nib(), forCellWithReuseIdentifier: "ImageCell")
        
        // MARK: - : init bank card views
        self.bankCardViews.cardSelectedHandler = selectedItem
        self.bankCardViews.cellConfigurationHandler = configCell
        self.bankCardViews.cardProviderHandler = numeberOfCards
        self.bankCardViews.walletConfigurationHandler = configWalletCell
        self.bankCardViews.hasCards = false
        self.bankCardViews.shouldHideIPG = self.viewModel?.hasIPG == false
        
        self.index = BankCardCollectionView.isWalletIndex
        
        // MARK: - : config keyboards
        self.cvv2.textField.isSecureTextEntry = true
        self.cvv2.textField.keyboardType = .numberPad
        self.passCode.textField.isSecureTextEntry = true
        self.passCode.textField.keyboardType = .numberPad
        self.cardNo.textField.keyboardType = .numberPad
        
        self.passCode.maxLength = 12
        self.cvv2.maxLength = 4
        self.cardNo.maxLength = 19
        
        self.cardNo.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        self.cardNo.textField.addTarget(self, action: #selector(lengthDidChange(_:)), for: .editingChanged)
        self.cvv2.textField.addTarget(self, action: #selector(lengthDidChange(_:)), for: .editingChanged)
        self.passCode.textField.addTarget(self, action: #selector(lengthDidChange(_:)), for: .editingChanged)
        self.expireDate.textField.addTarget(self, action: #selector(lengthDidChange(_:)), for: .allEvents)
        self.expireDate.isResponseToCopyPaste = false
        
        addInputAccessoryForTextFields(textFields: [self.cardNo.textField, self.cvv2.textField, self.passCode.textField], dismissable: true, previousNextable: false)
        
        // MARK: - : config navigation headers
        self.title = "پرداخت با دیجی‌پی"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "IRANYekan-Light", size: 18)!]
        let cancelBtn = UIBarButtonItem(title: "انصراف",
                                        style: .plain,
                                        target: self,
                                        action: #selector(cancel))
        
        cancelBtn.setTitleTextAttributes([.font: UIFont(name: "IRANYekan", size: 14.0)!], for: [.normal])
        cancelBtn.setTitleTextAttributes([.font: UIFont(name: "IRANYekan", size: 14.0)!], for: [.highlighted])
        
        cancelBtn.setTitleTextAttributes([.font: UIFont(name: "IRANYekan", size: 14.0)!], for: [.focused])
        
        cancelBtn.tintColor = SDKColors.Decline
        self.navigationItem.leftBarButtonItem = cancelBtn
        
        // MARK: - : Config Rounded View
        
        self.payButton.setTitleColor(.white, for: .normal)
        self.payButton.isEnabled = false
        self.view.layoutIfNeeded()
        
        // disable multi touch for two touch tapped in same time
        self.payButton.isExclusiveTouch = true
        
        keyboardObserver.observe {[weak self] (event) in
            guard let `self` = self else { return }
            
            switch event.type {
            case .willHide, .willChangeFrame, .willShow :
                
                var distance = event.type == .willHide ? 8 : event.keyboardFrameEnd.height - self.amountBackView.bounds.height
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    distance = event.type == .willHide ? 8 : event.keyboardFrameEnd.height - (UIScreen.main.bounds.height - self.view.bounds.height + (self.amountBackView.bounds.height / 2))
                }
                
                UIView.animate(withDuration: event.duration,
                               delay: 0.0,
                               options: [.allowUserInteraction, .beginFromCurrentState, event.options],
                               animations: {
                                self.scrollViewBottomConstraint.constant = distance
                                self.view.layoutIfNeeded()
                }, completion: nil)
                
            default:
                break
            }
            
        }
        
        self.view.isMultipleTouchEnabled = false
        
    }
    private func getDates(month: Int, year: Int) {
        var tempMonth = ""
        if month > 9 {
            tempMonth = "\(month)"
        }
        else {
            tempMonth = "0\(month)"
        }
        self.expireDate.textField.text = "\(year)/\(tempMonth)".persian
        self.selectedCard.expireDate = "\(year)/\(tempMonth)"
        self.newCell?.expireDate.text = "\(year)/\(tempMonth)".persian
    }
    
}
