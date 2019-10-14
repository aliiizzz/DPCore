//
//  IPGCardCollectionViewCell.swift
//  DPCore
//
//  Created by Farshad Mousalou on 6/2/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import UIKit

class IPGCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bgdView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.logoImage = UIImage(named: "MediumFullLogo",
                                 in: Bundle(for: type(of: self)),
                                 compatibleWith: nil)
        self.logoImageView.image = logoImage
        
        bgdView.layer.borderWidth = 1
        bgdView.layer.borderColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1).cgColor
        bgdView.layer.cornerRadius = 8
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1).cgColor
        self.layer.cornerRadius = 8
        // Initialization code
    }
    
    private var logoImage: UIImage?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.logoImageView.image = logoImage
        
        bgdView.layer.borderWidth = 1
        bgdView.layer.borderColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1).cgColor
        bgdView.layer.cornerRadius = 8
      
    }
    
}
