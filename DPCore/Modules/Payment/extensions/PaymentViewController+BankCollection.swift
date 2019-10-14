//
//  PaymentViewController+BankCollection.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-11-16.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

extension PaymentViewController {
    
    func numeberOfCards(_ cardCollectionView: BankCardCollectionView) -> Int {
        return self.viewModel?.cards.value.count ?? 0
    }
    
    func selectedItem(_ cardCollectionView: BankCardCollectionView, _ index: Int) {
       
        printDebug(index)
        clearTextFieldsIfNeeded()
        updateTextFieldsIfNeeded(for: index, animated: true)
        
        guard let selectedItem = self.viewModel?.cards.value[safe:index] else {
            
            guard index != BankCardCollectionView.isWalletIndex else {
                
                if let vm = self.viewModel {
                    self.payButton.isEnabled = vm.isEnoughWalletAmount
                }
                
                return
            }
            
            self.newCell = cardCollectionView.cellForItem(at: index)
            self.newCell?.emptyBackCard()
            return
        }
        
        self.newCell = nil
        let item = selectedItem
        self.selectedCard = Source(value: item.cardIndex, type: 2, expireDate: item.expireDate, prefix: item.prefix, postfix: item.postfix)
       
    }
    
    func configCell(_ cardCollectionView: BankCardCollectionView, _ cell: BankCardViewCell, _ index: Int) {
        
        cell.isLoading = self.viewModel?.cardsViewModel.isFetchingCards.value ?? false
        
        if let card = self.viewModel?.cards.value[safe:index] {
            cell.set(data: card)
        }
        else {
            cell.emptyBackCard()
        }
        
    }
    
    func configWalletCell(_ cardCollectionView: BankCardCollectionView, _ cell: WalletCardViewCell, _ index: Int) {
        if let viewModel = viewModel {
            cell.config(amount: viewModel.walletAmount, enoughAmount: viewModel.isEnoughWalletAmount)
        }
    }
    
    func updateTextFieldsIfNeeded(for newIndex: Int, animated: Bool = false) {
        
        var shouldUpdateLayout: Bool = false
        let oldIndex = self.index
        
        let cardCount = viewModel?.cards.value.count ?? 0
        
        // compare newIndex and oldIndex for update layouts if Needed
        switch (newIndex, oldIndex) {
            
        // switch between New Card and Wallet Card when User has no cards in list
        case (BankCardCollectionView.isNewIndex, BankCardCollectionView.isWalletIndex),
             (BankCardCollectionView.isWalletIndex, BankCardCollectionView.isNewIndex):
            self.hideTextFields(hide: newIndex == BankCardCollectionView.isWalletIndex, animated: animated)
            shouldUpdateLayout = false
            
        // switch between Cards and Wallet
        case (BankCardCollectionView.isWalletIndex, 0..<cardCount),
             (0..<cardCount, BankCardCollectionView.isWalletIndex):
            shouldUpdateLayout = true
        // switch between Cards and New Card
        case (BankCardCollectionView.isNewIndex, 0..<cardCount),
             (0..<cardCount, BankCardCollectionView.isNewIndex):
            shouldUpdateLayout = true
        default:
            shouldUpdateLayout = false
        }
        
        self.index = newIndex
        
        guard newIndex != BankCardCollectionView.isIPGIndex else {
            hideIPGContainerView(hide: false)
            return
        }
        
        hideIPGContainerView(hide: true)
        
        guard shouldUpdateLayout else { return }
        
        let animationBlock : () -> Void
        
        // hide Text Fields StackView when WalledCard selected
        self.hidePinCodeRow(hide: newIndex == BankCardCollectionView.isWalletIndex, animated: animated)
        
        // hide Card Number Text and Expire Date Field when Card is selected
        let shoudHide = newIndex != BankCardCollectionView.isNewIndex
        
        animationBlock = { [weak self] in
            
            guard let `self` = self else { return }

            self.cardNo.alpha = shoudHide ? 0.0 : 1.0
            self.cardNo.isHidden = shoudHide
            self.expireDate.alpha = shoudHide ? 0.0 : 1.0
            self.expireDate.isHidden = shoudHide
            
            UIView.performWithoutAnimation {

            }
            
        }
        
        guard animated else { animationBlock(); return}
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseOut],
                       animations: animationBlock) { (finished) in
                        guard finished else { return }
                        self.cardNo.isHidden = shoudHide
                        self.expireDate.isHidden = shoudHide
        }

    }
    
    private func hidePinCodeRow(hide: Bool, animated: Bool) {
       
        guard self.stackView.arrangedSubviews[safe:1]?.isHidden != hide else { return }
        
        let animationBlock = { [weak self] in
            
            guard let `self` = self else { return }
            
            self.stackView.arrangedSubviews[safe:1]?.alpha = hide ? 0.0 : 1.0
            self.stackView.arrangedSubviews[safe:1]?.isHidden = hide
            
        }
        
        guard animated else { animationBlock(); return}
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseOut],
                       animations: animationBlock) { (finished) in
                        guard finished else { return }
        }
    }
    
    private func hideTextFields(hide: Bool, animated: Bool) {
        
        guard self.stackView.arrangedSubviews.first?.isHidden != hide else { return }
        
        let animationBlock = { [weak self] in
            
            guard let `self` = self else { return }
            
            self.stackView.arrangedSubviews.forEach({ (view) in
                view.alpha = hide ? 0.0 : 1.0
                view.isHidden = hide
                
            })
            
        }
        
        guard animated else { animationBlock(); return}
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseOut],
                       animations: animationBlock) { (finished) in
                        guard finished else { return }
        }

    }
    
    private func hideIPGContainerView(hide: Bool) {
        
        guard self.ipgContainerView.isHidden != hide else {
            return
        }
        
        let fromAlpha: CGFloat = hide ? 1.0 : 0.0
        let toAlpha: CGFloat = hide ? 0.0 : 1.0
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseOut],
                       animations: { [weak self] in
                        self?.ipgContainerView.alpha = toAlpha
                        self?.paymentInputContainerView.alpha = fromAlpha
                        
        }) {[weak self] (finished) in
            guard finished else { return }
            self?.ipgContainerView.isHidden = hide
            self?.paymentInputContainerView.isHidden = !hide
        }
    }
    
    func clearTextFieldsIfNeeded() {
        self.cvv2.textField.resignFirstResponder()
        self.cvv2.text = nil
        self.passCode.textField.resignFirstResponder()
        self.passCode.text = nil
        self.expireDate.textField.resignFirstResponder()
        self.expireDate.textField.text = nil
        self.cardNo.textField.resignFirstResponder()
        self.cardNo.textField.text = nil
        self.payButton.isEnabled = false
        self.cardNo.hintText = nil
    }
    
}
