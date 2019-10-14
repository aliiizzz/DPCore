//
//  UserOTPCodeInputable.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/8/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

protocol UserOTPCodeInputable {
    
    var ticket: String { get }
    var userDetail: UserDetail { get}
    var features: [ProtectedFeatureKey] { get }
    var isRequired: Bool { get }
    var completion : (_ result: Bool) -> Void { get set }
    
}
