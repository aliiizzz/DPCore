//
//  ViewModel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-15.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

protocol ViewModel {
    
    associatedtype Input
    associatedtype Output
    associatedtype Service: AnyService
    func transform(input: Input) -> Output
    
}
