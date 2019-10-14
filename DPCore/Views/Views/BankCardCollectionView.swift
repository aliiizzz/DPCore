//
//  BankCardCollectionView.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/15/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

/// BankCardCollectionView
//TODO: document this class
@IBDesignable
class BankCardCollectionView: UICollectionView {
    
    static let isNewIndex = -1
    static let isWalletIndex = -2
    static let isIPGIndex = -3
    
    private let cellId = "BankCardCollectionCellId"
    private let walletCellId = "WalletCardCollectionCellId"
    private let ipgCellId = "IPGCardCollectionCellId"
    
    private var hasWindow: Bool = false
    
    /// <#Description#>
    var hasCards: Bool = true {
        didSet {
            
            guard oldValue != hasCards else {
                return 
            }
            guard hasWindow else { return }
            updateCardCollectionLayout(with: hasCards ? nil : 0.91)
            self.reloadData()
        }
    }
    
    var shouldHideWallet: Bool = true {
        didSet {
            
            guard oldValue != shouldHideWallet else {
                return
            }
            guard hasWindow else { return }
            self.reloadData()
        }
    }
    
    var shouldHideIPG: Bool = true {
        
        didSet {
            guard oldValue != shouldHideIPG else {
                return
            }
            guard hasWindow else { return }
            self.reloadData()
        }
    }
    
    var shouldHideCards: Bool = false {
        
        didSet {
            
            guard oldValue != shouldHideCards else {
                return
            }
            guard hasWindow else { return }
            self.reloadData()
        }
    }
    
    /// The alpha to apply on the cells that are away from the center. Should be
    /// in range [0, 1]. 0.65 by default.
    @IBInspectable
    var minAlpha: CGFloat = 0.65 {
        didSet {
            updateCardCollectionLayout()
        }
    }
    
    /// The spacing ratio between two cells. 0.425 by default.
    @IBInspectable
    var itemSpacing: CGFloat = 0.425 {
        didSet {
            updateCardCollectionLayout()
        }
    }
    
    /// The scale rate that will applied to the cells to make it into a card. 0.75 by default
    @IBInspectable
    var scaleRate: CGFloat = 0.75 {
        didSet {
            updateCardCollectionLayout()
        }
    }
    
    private var cardCollectionViewLayout: CenteredCollectionViewLayout? {
        return self.collectionViewLayout as? CenteredCollectionViewLayout
    }
    
    /// <#Description#>
    typealias CellConfigurationHandler = (_ cardCollectionView: BankCardCollectionView, _ cell: BankCardViewCell, _ index: Int) -> Void
    typealias WalletCellConfigurationHandler = (_ cardCollectionView: BankCardCollectionView, _ cell: WalletCardViewCell, _ index: Int) -> Void
    
    /// <#Description#>
    typealias NumberOfItemsProviderHandler = (_ cardCollectionView: BankCardCollectionView) -> (Int)
    
    /// <#Description#>
    typealias ItemDidSelectHandler = (_ cardCollectionView: BankCardCollectionView, _ index: Int) -> Void
    
    /// <#Description#>
    var cellConfigurationHandler: CellConfigurationHandler?
    
    var walletConfigurationHandler: WalletCellConfigurationHandler?
    
    /// <#Description#>
    var cardProviderHandler: NumberOfItemsProviderHandler?
    
    /// <#Description#>
    var cardSelectedHandler: ItemDidSelectHandler?
    
    private var animator = LinearCardAttributesAnimator()
    
    deinit {
        cellConfigurationHandler = nil
        cardProviderHandler = nil
        cardSelectedHandler = nil
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.configLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configLayouts()
        
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard newWindow != nil else {
            self.hasWindow = false
            return
        }
        
        self.hasWindow = true

        updateCardCollectionLayout(with: hasCards ? nil : 0.91)
        self.reloadData()
    }
    
    private func configLayouts() {
        
        decelerationRate = UIScrollViewDecelerationRateNormal - 10
        
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.register(BankCardViewCell.nib(), forCellWithReuseIdentifier: cellId)
        self.register(WalletCardViewCell.nib(), forCellWithReuseIdentifier: walletCellId)
        self.register(IPGCardCollectionViewCell.nib(), forCellWithReuseIdentifier: ipgCellId)
        
        configCardCollectionLayoutIfNeeded()
        
        self.delegate = self
        self.dataSource = self
        self.allowsSelection = false
        self.allowsMultipleSelection = false
        updateCardCollectionLayout()
        
    }
    
    private func configCardCollectionLayoutIfNeeded() {
        
        var cardCollectionViewLayout: CenteredCollectionViewLayout
        
        if self.cardCollectionViewLayout == nil {
            
            cardCollectionViewLayout = CenteredCollectionViewLayout()
            
            if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
                cardCollectionViewLayout.scrollDirection = flowLayout.scrollDirection
            }
            
            self.collectionViewLayout = cardCollectionViewLayout
            
        }
        else if let collectionViewLayout = self.collectionViewLayout as? CenteredCollectionViewLayout {
            cardCollectionViewLayout = collectionViewLayout
        }
        
    }
    
    private func updateCardCollectionLayout(with scaleRate: CGFloat? = nil) {
        
        animator.itemSpacing = itemSpacing
        animator.minAlpha = minAlpha
        if let scaleRate = scaleRate {
            animator.scaleRate = scaleRate
        }
        else {
            animator.scaleRate = self.scaleRate
        }
        
        cardCollectionViewLayout?.animator = self.animator
        cardCollectionViewLayout?.invalidateLayout()
        
    }
    
    func cellForItem(at index: Int) -> BankCardViewCell? {
        
        let itemCount = numberOfItems()
        
        switch (index) {
        case (BankCardCollectionView.isNewIndex) where itemCount == 0:
            return self.cellForItem(at: IndexPath(item: itemCount + 1, section: 0)) as? BankCardViewCell
        case (BankCardCollectionView.isNewIndex) where itemCount > 0:
            return self.cellForItem(at: IndexPath(item: itemCount + 1, section: 0)) as? BankCardViewCell
            
        case (BankCardCollectionView.isWalletIndex) where itemCount == 0:
            return nil
        case (BankCardCollectionView.isWalletIndex) where itemCount > 0:
            return nil
        
        case (BankCardCollectionView.isIPGIndex) where itemCount == 0:
            return nil
        case (BankCardCollectionView.isIPGIndex) where itemCount > 0:
            return nil
            
        default:
            return self.cellForItem(at: IndexPath(item: index + 1, section: 0)) as? BankCardViewCell
        }
        
    }
    
    func scrollToItem(at index: Int, at scrollPosition: UICollectionViewScrollPosition, animated: Bool) {
        
        let itemCount = numberOfItems()
        
        var offset: Int = 0
        
        if shouldHideWallet {
            offset = 0
        }
        else {
            offset = 1
        }
        
        switch (index) {
        case (BankCardCollectionView.isNewIndex):
            super.scrollToItem(at: IndexPath(item: itemCount + offset, section: 0), at: scrollPosition, animated: animated)
        case (BankCardCollectionView.isWalletIndex):
            self.scrollToItem(at: IndexPath(item: 0, section: 0), at: scrollPosition, animated: animated)
        case (BankCardCollectionView.isIPGIndex) :
            
            if shouldHideIPG {
                offset += 0
            }
            else {
                offset += 1
            }
            
            super.scrollToItem(at: IndexPath(item: itemCount + offset, section: 0), at: scrollPosition, animated: animated)
            
        default:
            
            if 0..<itemCount ~= index {
                self.scrollToItem(at: IndexPath(item: index + offset, section: 0), at: scrollPosition, animated: animated)
            }
        }
    }

}

// MARK: - UICollectionViewDataSourc
extension BankCardCollectionView: UICollectionViewDataSource {
    
    private func numberOfItems() -> Int {
        return self.cardProviderHandler?(self) ?? 0
    }
    
    private func numberOfItems(in section: Int) -> Int {
        
        switch (!shouldHideIPG, !shouldHideWallet, !shouldHideCards) {
        case (false, false, false):
            return 0
        case (true, true, _ ):
            return 2
        case (_, true, true) :
            return self.numberOfItems() + 2
        case (_, true, false) :
            return 1
        case (_, false, true) :
            return self.numberOfItems() + 1
        default:
            return 0
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return self.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cellId: String = self.cellId
        
        if !shouldHideWallet, indexPath.item == 0 {
            cellId = walletCellId
        }
        
        if !shouldHideIPG, indexPath.item == self.numberOfItems(inSection: indexPath.section) - 1 {
            cellId = ipgCellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        if cellId == walletCellId, let cell = cell as? WalletCardViewCell {
            self.walletConfigurationHandler?(self, cell, BankCardCollectionView.isWalletIndex)
            return cell
        }
        
        if cellId == ipgCellId, let cell = cell as? IPGCardCollectionViewCell {
            return cell
        }
        
        let correctIndex: Int
        let numberOfItems = self.numberOfItems()
        
        switch (shouldHideWallet, indexPath.row) {
            
        case (true, let index):
            
            if index < numberOfItems {
                correctIndex = index
            }
            else { correctIndex = BankCardCollectionView.isNewIndex }
            
        case (false, let index):
            
            if index < numberOfItems + 1 {
                correctIndex = index - 1
            }
                
            else { correctIndex = BankCardCollectionView.isNewIndex }
            
        }
        
        let bankCell = cell as! BankCardViewCell
        
        self.cellConfigurationHandler?(self, bankCell, correctIndex)
        //        cell.clipsToBounds = true
        return cell
        
    }
    
}

// MARK: - <#UIScrollViewDelegate#>
extension BankCardCollectionView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let item = self.cardCollectionViewLayout?.currentCenteredPage else { return }
        
        let correctIndex: Int
        let numberOfItems = self.numberOfItems()
        
        switch (shouldHideWallet, item) {
        case (true, let index):
            
            if index < numberOfItems {
                correctIndex = index
            }
            else { correctIndex = BankCardCollectionView.isNewIndex }
            
        case (false, let index):
            
            if index == 0 {
                correctIndex = BankCardCollectionView.isWalletIndex
            }
            else if index < numberOfItems + 1 {
                correctIndex = index - 1
            }
            else if index == numberOfItems + 1, shouldHideCards == false {
                
                correctIndex = BankCardCollectionView.isNewIndex
            }
            else {
                correctIndex = BankCardCollectionView.isIPGIndex
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let `self` = self else { return }
            self.cardSelectedHandler?(self, correctIndex)
        }
        
    }
    
}

// MARK: - UICollectionViewDelegate
extension BankCardCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BankCardCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        guard let animator = animator else { return view.bounds.size }
        
        var rect: CGRect = UI_USER_INTERFACE_IDIOM() == .pad ? CGRect(origin: bounds.origin, size: CGSize(width: 375, height: bounds.height)) : collectionView.bounds
        
        if self.numberOfItems() != 0 {
            rect = UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        }
        else if shouldHideWallet {
            rect = UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0))
        }
        else {
            rect = UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        }
        
        return rect.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
