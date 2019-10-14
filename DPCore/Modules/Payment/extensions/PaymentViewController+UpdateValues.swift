//
//  PaymentViewController+UpdateValues.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-11-16.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit

extension PaymentViewController {
    
    func updateBanks(_ data: [BankModel]) {
        self.bankList = data
    }
    
    func updateCards(_ data: [Card]) {
       
        let cards = data
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            
            guard let `self` = self else { return }
            self.stackView.isHidden = false
            self.bankCardViews.reloadData()
            
            self.index = BankCardCollectionView.isNewIndex
            let cardIndex: Int
            if let vm = self.viewModel {
                
                self.bankCardViews.shouldHideCards = !vm.isShowCards
                
                switch (data.count, vm.isShowWallet && vm.isEnoughWalletAmount) {
                case (0, false):
                    cardIndex = BankCardCollectionView.isNewIndex
                case (_, false):
                    cardIndex = 0
                default :
                    cardIndex = BankCardCollectionView.isWalletIndex
                    
                }
                
                self.updateTextFieldsIfNeeded(for: BankCardCollectionView.isWalletIndex, animated: true)
                
                if cards.count > 0 {
                    // by default new card selected but if we have card we need select first item after cards fetched from server
                    if let item = cards[safe:0], cardIndex == 0 {
                        
                        self.selectedCard = Source(value: item.cardIndex,
                                                   type: 2,
                                                   expireDate: item.expireDate,
                                                   prefix: item.prefix,
                                                   postfix: item.postfix)
                    }
                    
                }
                
                let duration = UI_USER_INTERFACE_IDIOM() == .pad ? 0.0 : 2.5
                self.bankCardViews.hasCards = (vm.isShowCards || vm.isShowWallet || data.isEmpty == false)
                
                UIView.animate(withDuration: duration,
                               delay: 0.5,
                               options: [.allowUserInteraction, .beginFromCurrentState],
                               animations: { [weak self] in
                                 self?.bankCardViews.hasCards = data.isEmpty == false || self?.viewModel?.isShowCards == true 
                                if cardIndex != BankCardCollectionView.isWalletIndex {
                                    
                                    UIView.performWithoutAnimation {
                                        self?.bankCardViews.scrollToItem(at: cardIndex, at: .centeredHorizontally, animated: true)
                                    }
                                    
                                }
                                
                                UIView.performWithoutAnimation {
                                    self?.updateTextFieldsIfNeeded(for: cardIndex, animated: true)
                                }
                    
                }) { _ in
                    
                }
                
            }
        }
        
    }
    
    func update(wallet: Int?) {
        
        if let vm = viewModel {
            
            self.bankCardViews.shouldHideCards = !vm.isShowCards
            self.bankCardViews.shouldHideWallet = !vm.isShowWallet

            self.stackView.isHidden = false
            
            if vm.isShowCards == false {
                self.bankCardViews.hasCards = false || vm.hasIPG
                
                self.index = BankCardCollectionView.isNewIndex
                self.updateTextFieldsIfNeeded(for: BankCardCollectionView.isWalletIndex, animated: false)
            }
        
            if vm.isShowWallet, vm.hasIPG {
                 self.bankCardViews.scrollToItem(at: BankCardCollectionView.isWalletIndex, at: .centeredHorizontally, animated: false)
            }
            
        }
        
        if viewModel?.isShowWallet == false {
            return
        }
        
        self.payButton.isEnabled = self.viewModel?.isEnoughWalletAmount ?? false
        
    }
    
}
