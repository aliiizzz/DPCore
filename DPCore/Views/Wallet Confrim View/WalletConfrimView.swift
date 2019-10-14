//
//  WalletConfrimView.swift
//  DPCore
//
//  Created by Farshad Mousalou on 12/8/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class WalletConfrimView: UIView, Modal {

    var timeInterval: Double?
    var backgroundShadow: UIColor = SDKColors.LightGray
    var backgroundView: UIView = UIView()
    var dialogView: UIView = UIView()
    
    var action: ((WalletConfrimView, Bool) -> Void)?
    
    deinit {
        action = nil
    }
    
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func confrimAction( _ sender: UIButton? ) {
        action?(self, true)
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction( _ sender: UIButton? ) {
        action?(self, false)
        self.dismiss(animated: true)
    }
    
    func addWallet(view: UIView) {
        self.cardContainerView.addSubview(view)
        constSetter(view, to: self.cardContainerView, const: 0)
    }

}
