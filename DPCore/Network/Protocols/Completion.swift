//
//  Completion.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-10-09.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal typealias Completion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

internal typealias ResponseCompletion = (_ data: Decodable?, _ response: String?, _ error: Error?) -> Void
