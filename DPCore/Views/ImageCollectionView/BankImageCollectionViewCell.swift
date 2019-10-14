//
//  BankImageCollectionViewCell.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-11-16.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class BankImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var images: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
