//
//  ReceiptCell.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-08-17.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class ReceiptCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
