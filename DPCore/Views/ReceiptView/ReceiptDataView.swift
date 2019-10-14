//
//  ReceiptDataView.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/13/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

@IBDesignable
class ReceiptDataView: RoundedView {
    
    @IBOutlet private(set) weak var businessLabel: UILabel!
    @IBOutlet private(set) weak var priceLabel: UILabel!
    @IBOutlet private(set) weak var imageIdImageView: UIImageView!
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var tableViewHeightObserver: NSKeyValueObservation!
    
    var imageId: UIImage? {
        didSet {
            self.imageIdImageView.image = imageId
        }
    }
    
    deinit {
        tableViewHeightObserver.invalidate()
        tableViewHeightObserver = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundingCorners = [.allCorners]
        self.businessLabel.text = nil
        self.priceLabel.text = nil
        self.isUserInteractionEnabled = true
        guard tableViewHeightObserver == nil else { return }
        
        tableViewHeightObserver = self.tableView.observe(\.contentSize, options: [.new, .old], changeHandler: {[weak self] (_, changed) in
            
            guard let `self` = self else { return }
            
            guard let newValue = changed.newValue?.height, let oldValue = changed.oldValue?.height else { return }
            
            guard newValue != oldValue else { return }
            
            self.updateContentSize()
            
        })
        
    }
    
    func fetchImage(id: String?) {
        guard let id = id else { return }
        self.imageIdImageView.load(id)
    }
    
    func config(businessName: String, price: String) {
        self.businessLabel.text = businessName
        //FIXME: replace localized string
        self.priceLabel.text = "\(price) ریال".persian
    }
    
    func config(businessName: String, price: Int) {
        config(businessName: businessName, price: "\(price)")
    }
    
    func config(topUpName: String, price: String) {
        config(businessName: topUpName, price: price)
    }
    
    func config(topUpName: String, price: Int) {
        config(businessName: topUpName, price: "\(price)" )
    }
    
    private func updateContentSize() {
        
        guard let superView = superview else { return }
        
        let tVContenHeight = self.tableView.contentSize.height
        guard tVContenHeight > 0.0001 else { return }
        
        let result = tVContenHeight < superView.bounds.height - self.tableView.frame.minY
        if  result {
            
            self.tableViewHeightConstraint.constant = tVContenHeight
            self.layoutIfNeeded()
            
        }
        
        self.tableView.isScrollEnabled = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
