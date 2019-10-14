//
//  PaymentViewController+TextDelegate.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-17.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

extension PaymentViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        self.newCell?.cardNo.text = textField.text?.digits.english.cardFormatted.persian
        textField.text = textField.text?.digits.english.cardFormatted.persian
        let text = (textField.text?.english.digits) ?? ""
        if text.count < 6 {
            self.newCell?.emptyBackCard()
        }
        if text.count >= 6 {
            DispatchQueue.main.async {
                
                if let bank = self.viewModel?.matchBanks(prefix: String(text.prefix(6))) {
                    self.newCell?.set(bank: bank)
                    self.cardNo.hintText = nil
                    self.cardNo.textFieldType = .normal
                }
                else {
                    self.payButton.isEnabled = false
                    self.cardNo.hintText = "شماره کارت واردشده به هیچ بانکی تعلق ندارد."
                    self.cardNo.textFieldType = .error
                }
            }
        }
        if text.count == 19 {
            self.selectedCard.postfix = String(text.dropFirst(12))
            
        }
    }
    //    TODO: FIX it with replace with validator
    @objc func lengthDidChange(_ textField: UITextField) {
        
        self.payButton.isEnabled = false
        if self.index == BankCardCollectionView.isNewIndex {
            if (self.cvv2.textField.text?.count)! > 2
                && (self.cardNo.textField.text?.count)! == 19
                && self.expireDate.textField.text != ""
                && (self.passCode.textField.text?.count)! > 4 {
                self.payButton.isEnabled = self.cardNo.textFieldType != .error
            }
        }
        else {
            if (self.cvv2.textField.text?.count)! > 2
                && (self.passCode.textField.text?.count)! > 4 {
                self.payButton.isEnabled = true
            }
        }
      
    }
}
