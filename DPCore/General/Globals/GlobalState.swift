//
//  GlobalState.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-06.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

enum SDKState {
    case start
    case tac
    case payment
}

@available(iOS, deprecated:1.3, message: "this struct is deprecated")
struct GlobalState {
    static var previousState: SDKState? = .start
    static var currentState: SDKState? = .start
    static var nextState: SDKState? = .start
}
