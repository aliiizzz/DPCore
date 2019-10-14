//
//  BillModel.swift
//  DPCore
//
//  Created by Farshad Mousalou on 12/23/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

struct BillModel: Codable {

    let billId: String
    let payId: String
    let amount: Int
    let feeCharge: Int?
    let name: String
    let imageId: String
    
}
