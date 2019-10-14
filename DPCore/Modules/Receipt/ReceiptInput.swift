//
//  ReceiptInput.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/11/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

@objc public enum DPMode: Int {
    case pay
    case topUp
    case bill
}

enum DPPayData {
    case pay(value: PayResponse)
    case generic(value: Any)
}

struct ReceiptInput {
    let status: DPStatus
    let mode: DPMode = .pay
    let data: DPPayData
    let error: Error?
}
