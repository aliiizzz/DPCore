//
//  Message.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-15.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

protocol Messagable {
    var message: MessageModel { get }
    var theme: MessageTheme? { get }
    var canRetry: Bool { get }
}

extension Messagable {
    var theme: MessageTheme? {
        return .default
    }
}

// MARK: - TODO: duplicate fix it with snack bar view
struct Action {
    let title: String
    let action: () -> Void
}

struct MessageModel {
    let title: String
    let duration: TimeInterval
    let description: String?
    let icon: UIImage?
    /// if not nil, icon will be replaced with retry icon
    var action: Action?
    
    init(title: String, duration: TimeInterval = 3.0, description: String? = nil, icon: UIImage? = nil, action: Action? = nil) {
        self.title = title
        self.duration = duration
        self.description = description
        self.icon = icon
        self.action = action
    }
}
struct MessageTheme {
    let background: UIColor
    let tint: UIColor
}

extension MessageTheme {
    static let `default` = MessageTheme(background: UIColor.lightGray, tint: UIColor.black)
    
    static let error = MessageTheme(background: UIColor.red,
                                    tint: .white)
    
    static let warning = MessageTheme(background: UIColor.orange,
                                      tint: .white)
    
    static let info = MessageTheme(background: UIColor.green,
                                   tint: .white)
}
