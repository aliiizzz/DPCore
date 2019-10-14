//
//  Encodable+dict.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
