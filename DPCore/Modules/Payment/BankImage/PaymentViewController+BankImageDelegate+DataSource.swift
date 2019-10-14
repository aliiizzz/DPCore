//
//  PaymentViewController+BankImageDelegate+DataSource.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-11-16.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard collectionView == self.bankImages else {
            return viewModel?.ipgImages.value.count ?? 0
        }
        
        return viewModel?.images.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? BankImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard collectionView == self.bankImages else {
            
            if let imageURL = self.viewModel?.ipgImages.value.reversed()[indexPath.item] {
                cell.images.load(imageURL)
            }
            
            return cell
        }
        
        if let imageURL = self.viewModel?.images.value.reversed()[indexPath.item] {
            cell.images.load(imageURL)
        }
        
        printDebug("Cell: \(cell)")
        return cell
    }
    
}

extension PaymentViewController: UICollectionViewDelegate {
    
}
