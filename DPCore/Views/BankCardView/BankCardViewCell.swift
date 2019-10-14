//
//  BankCardView.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-09-05.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class BankCardViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardName: UILabel!
    
    @IBOutlet weak var bankLogo: RoundedImageView!
    @IBOutlet weak var backView: BankCardGradientsView!
    @IBOutlet weak var logoBackView: RoundedView!
    @IBOutlet weak var logoRoundedView: GradientView!
    
    @IBOutlet weak var cardNo: UILabel!
    @IBOutlet weak var cardHolder: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    fileprivate var addButton: UIButton!
    fileprivate var bottomLabel: UILabel!
    private(set) var card: Card?

    var isLoading: Bool = false {
        didSet {
            updateLoadingUI()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fromNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        backView.cornerRadius = 8
        logoBackView.backgroundColor = .clear
        logoBackView.clipsToBounds = true
        logoBackView.roundingCorners = [.bottomRight, .bottomLeft]
        self.emptyBackCard()
        // Initialization code
        self.isLoading = false
    }
    
    override func prepareForReuse() {
        self.isLoading = false
        self.bankLogo.image = nil
        self.emptyBackCard()
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = logoBackView.frame.width / 2
        logoBackView.cornerRadiusSize = CGSize(width: radius, height: radius)
        
        bankLogo.cornerRadius = Float(bankLogo.frame.width / 2)
        self.logoRoundedView.cornerRadius =  bankLogo.frame.width / 2
        
    }
    
    func set(data card: Card) {
        self.card = card
        self.cardNo.text = (card.prefix + "******" + card.postfix).maskCard.persian
        self.cardHolder.text = ""
        self.cardName.text = card.bankName
        self.expireDate.text = card.expireDate.persian
        self.changeGradiant(colorArray: card.colorRange)
        self.bankLogo.load(card.imageId)
    }
    
    func set(bank data: BankModel) {
        self.cardName.text = data.name
        self.changeGradiant(colorArray: data.colorRange)
        self.bankLogo.load(data.imageId)

    }
    
    func showEmptyCard() {
        
        emptyCardCreator()
        // use to replace card view's item with plus and a label
        
    }
    
    private func emptyCardCreator() {
        self.cardName.text = "کارت جدید"
        self.cardNo.text = "شماره کارت"
        self.expireDate.text = "----/----"
        self.backView.topColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        self.backView.bottomColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        self.cardHolder.text = ""
        self.bankLogo.image = UIImage(named: "bank", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
    }
    
    func emptyBackCard() {
        self.cardName.text = "کارت جدید"
        self.cardNo.text = "شماره کارت"
        self.expireDate.text = "----/----"
        self.backView.topColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        self.backView.bottomColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        self.cardHolder.text = ""
        self.bankLogo.image = UIImage(named: "bank", in: Bundle(for: type(of: self)), compatibleWith: nil)
    }
    
    func changeGradiant(colorArray: [Int]) {
        self.backView.topColor =  UIColor(hex: UInt(colorArray[0]))
        self.backView.bottomColor = UIColor(hex: UInt(colorArray[1]))
    }
    
    @objc func addCard() {
        
    }
    
    func  labelTitleSetter(title: String) {
        bottomLabel.text = title
    }
    
    struct BackFrame {
        static var frame = BankCardViewCell.frame
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }
    
    func updateLoadingUI() {
        
        for view in self.subviews where (view is UIActivityIndicatorView) == false && (view != self.backView) {
            
            view.isHidden = self.isLoading
        }
        
        self.loadingView.isHidden = !self.isLoading
        
        if self.isLoading {
            self.loadingView.startAnimating()
        }
        else {
            self.loadingView.stopAnimating()
        }
    }
    
}
