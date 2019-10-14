//
//  WalletCardViewCell.swift
//  DPCore
//
//  Created by Farshad Mousalou on 12/5/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class WalletCardViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.logoImage = UIImage(named: "walletLogo", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.logoImageView.image = logoImage
        // Initialization code
    }

    private var logoImage: UIImage?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.logoImageView.image = logoImage
        self.infoLabel.text = nil
        self.errorLabel.text = nil
        self.currencyLabel.text = nil
        self.amountLabel.text = nil
    }
    
    func config(amount: String?, enoughAmount: Bool = true) {
        
        prepareForPresentation()
        guard let amount = amount else {
            presentWalletNotAvaiable()
            return
        }
        
        if !enoughAmount {
            presentNotEnoughAmount()
        }
        
        self.amountLabel.text = amount
        
    }
    
    func prepareForPresentation() {
        
        self.infoLabel.isHidden = false
        self.currencyLabel.isHidden = false
        self.amountLabel.isHidden = false
        self.errorLabel.isHidden = true
        
        self.logoImageView.image = logoImage
        self.infoLabel.text = "موجودی کیف پول"
        self.currencyLabel.text = "ریال"
    }
    
    func presentWalletNotAvaiable() {
        
        self.infoLabel.isHidden = true
        self.currencyLabel.isHidden = true
        self.amountLabel.isHidden = true
        self.errorLabel.isHidden = false
        self.errorLabel.text = "در حال حاضر کیف پول در دسترس نمی باشد."
    }
    
    func presentNotEnoughAmount() {
        self.errorLabel.isHidden = false
        self.errorLabel.text = "موجودی کافی نیست."
    }
    
}
