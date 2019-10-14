//
//  ReceiptHeader.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-08-17.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class ReceiptHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var chargeTypeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var cellNumberLabel: UILabel!
    
    func setValues(data: [String]) {
        self.chargeTypeLabel.text = data[0]
        self.amountLabel.text = (Int(data[1])?.persianPrice ?? "") + " ریال"
        self.cellNumberLabel.text = data[2].english.digits.iranCellNumber.persian
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
