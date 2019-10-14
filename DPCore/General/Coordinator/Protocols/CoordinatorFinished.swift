//
//  CoordinatorFinished.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-24.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

protocol CoordinatorFinished {
    typealias T = Self
    var finish: ((T) -> Void)? { get set }
}
