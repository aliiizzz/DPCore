//
//  DateFormatter+Persian.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-22.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let `default`: DateFormatter = {
        $0.dateFormat = "YYYY-MM-dd HH:mm:ss"
        $0.timeZone = TimeZone.current
        return $0
    }(DateFormatter())
    
    static let persian: DateFormatter = {
        $0.calendar = Calendar(identifier: .persian)
        $0.dateFormat = "yyyy/MM/dd - HH:mm:ss"
        $0.locale = Locale(identifier: "fa-ir")
        $0.timeZone = .current//TimeZone(abbreviation: "IRST")
        return $0
    }(DateFormatter())
    
    static let persianMonth: DateFormatter = {
        $0.dateFormat = "MMMM YYYY"
        $0.timeZone = .current//TimeZone(abbreviation: "IRST")
        $0.locale = Locale(identifier: "fa-ir")
        return $0
    }(DateFormatter())
    
    static let persianMonthShort: DateFormatter = {
        $0.dateStyle = .long
        $0.locale = Locale(identifier: "fa_IR")
        $0.calendar = Calendar(identifier: Calendar.Identifier.persian)
        $0.dateFormat = "MMM"
        return $0
    }(DateFormatter())
    
    static let persianYearShort: DateFormatter = {
        $0.dateStyle = .long
        $0.locale = Locale(identifier: "fa_IR")
        $0.calendar = Calendar(identifier: Calendar.Identifier.persian)
        $0.dateFormat = "yyyy"
        return $0
    }(DateFormatter())
    
    static let persianDateLong: DateFormatter = {
        $0.dateStyle = .long
        $0.locale = Locale(identifier: "fa_IR")
        $0.calendar = Calendar(identifier: Calendar.Identifier.persian)
        $0.dateFormat = "\u{200F}dd MMM yyyy"
        return $0
    }(DateFormatter())
}

extension TimeInterval {
    var remaingingTime: String {
        var calender = Calendar.current
        calender.locale = Locale(identifier: "fa-ir")
        let formatter = DateComponentsFormatter()
        formatter.calendar = calender
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: self)!.replacingOccurrences(of: "،", with: " -")
    }
}
