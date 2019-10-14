//
//  StringExtension.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-22.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var persian: String {
        let chars = self.unicodeScalars.flatMap { unicode -> String in
            if let digit = Int(String(unicode)) {
                return digit.persian
            }
            else if String(unicode) == "ى"
                || String(unicode) == "ي" {
                return "ی"
            }
            else if String(unicode) == "ك" {
                return "ک"
            }
            else {
                return String(unicode)
            }
        }
        return String(chars)
    }
    
    var english: String {
        let chars = self.unicodeScalars.flatMap { unicode -> String in
            if let digit = NumberFormatter.persian.number(from: String(unicode)) {
                return String(describing: digit)
            }
            else {
                return String(unicode)
            }
        }
        return String(chars)
    }
    
    var spaceReduced: String {
        let chars = self.unicodeScalars.flatMap { unicode -> String in
            if CharacterSet.whitespaces.contains(unicode) {
                return ""
            }
            return String(unicode)
        }
        return String(chars)
    }
    
    var extractCellNumberLike: String? {
        let str = english
        if str.hasPrefix("0") {
            return str.spaceReduced.digits
        }
        else if hasPrefix("+") {
            let s = String(str[index(str.startIndex, offsetBy: 1)...])
            return "+" + s.spaceReduced.digits
        }
        return nil
    }
    
    var digits: String {
        return english.compactMap { Int(String($0)) }.reduce("") { $0 + String($1) }
    }
    
    var ibanFormatted: String {
        if self.count <= 2 {
            return String(self[self.startIndex..<self.index(self.startIndex,
                                                            offsetBy: self.count)])
        }
        
        var finalString = "-" + self[self.startIndex ..< self.index(self.startIndex, offsetBy: 2)]
        
        let subString = String(self[index(self.startIndex, offsetBy: 2)...])
        finalString += subString.enumerated().reduce("") { $0 + ($1.offset % 4 == 0 ? (" - " + String($1.element)) : String($1.element)) }
        
        finalString.removeFirst()
        
        return finalString
    }
    
    var telephoneFormatted: String {
        if let res = self.match(regex: "(0|\\+98|0098)[1-9][0-9]"),
            res.1.lowerBound == 0, res.0.count < self.count {
            
            return String(self[..<self.index(self.startIndex, offsetBy: res.1.count)]) +
                "-" +
                String(self[self.index(self.startIndex, offsetBy: res.1.count)...])
        }
        return self
    }
    
    var cardFormatted: String {
        var finalString: String = ""
        
        finalString = self.enumerated().reduce("") { $0 + ($1.offset % 4 == 0 ? ("-" + String($1.element)) : String($1.element)) }
        
        if finalString.count != 0 {
            finalString.removeFirst()
        }
        
        return finalString
    }
    var maskCard: String {
        var resultString = ""
        self.enumerated().forEach { (index, character) in
            if index < 12 && index > 5 {
                resultString += "x"
            }
            else {
                resultString.append(character)
            }
        }
        return resultString.cardFormatted
    }
    
    var unifiedCellNumber: String {
        if count >= 5 {
            if hasPrefix("00") {
                let s = String(self[index(startIndex, offsetBy: 4)...])
                return "+98" + s
            }
            if hasPrefix("0") {
                let s = String(self[index(startIndex, offsetBy: 1)...])
                return "+98" + s
            }
        }
        return self
    }
    
    var iranCellNumber: String {
        let str = unifiedCellNumber
        if str.hasPrefix("+98") {
            return "0" + String(str[index(startIndex, offsetBy: 3)...])
        }
        return self
    }
    
    var removeLeadingZero: String {
        let str = self.english
        
        let zero = str.prefix(while: { $0 == "0"})
        return String(str[str.index(str.startIndex, offsetBy: zero.count)...])
    }
    
    var nameFormatted: String {
        return self.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression, range: nil)
    }
    
    func match(regex: String) -> (String, CountableRange<Int>)? {
        guard let expression = try? NSRegularExpression(pattern: regex, options: []) else { return nil }
        let range = expression.rangeOfFirstMatch(in: self, options: [], range: NSRange(0 ..< self.utf16.count))
        if range.location != NSNotFound {
            return ((self as NSString).substring(with: range), range.location ..< range.location + range.length )
        }
        return nil
    }
    
    func incrementalSearch(with str: String) -> Bool {
        let chars = str
        var index = 0
        for char in self {
            if index == chars.count {
                break
            }
            if chars[chars.index(chars.startIndex, offsetBy: index)] == char {
                index += 1
            }
        }
        return index == chars.count
    }
    
    func search(with str: String) -> Bool {
        return localizedCaseInsensitiveContains(str)
        //        return contains(str)
    }
    
    func extractFirstNameAndLastName() -> (String?, String?) {
        let sections = self.components(separatedBy: CharacterSet.whitespaces)
        
        switch sections.count {
        case 0: return (nil, nil)
        case 1: return (sections[0], nil)
        case 2: return (sections[0], sections[1])
        default:
            if sections[0].persian == "سید" || sections[0].persian == "سیده" {
                return (sections[0] + " " + sections[1], sections[2..<sections.count].joined())
            }
            else {
                return (sections[0], sections[1..<sections.count].joined())
            }
        }
        
    }
}

extension String {
    mutating func convertHtml() -> NSAttributedString? {
        do {
           
            return try NSAttributedString(data: Data(self.utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        }
        catch {
            print("error: ", error)
            return nil
        }
    }
}

extension ExpressibleByUnicodeScalarLiteral where Self: ExpressibleByStringLiteral, Self.StringLiteralType == String {
    init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension ExpressibleByExtendedGraphemeClusterLiteral where Self: ExpressibleByStringLiteral, Self.StringLiteralType == String {
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension CharacterSet {
    static let persianAlphabets = CharacterSet(charactersIn: "اآبپتثجچحخدذرزژسشصضطظعغفقکگلمنوهیي‌ء")
    
    static let arabicAlphabets = CharacterSet(charactersIn: "اآبتثجحخدذرزسشصضطظعغفقكلمنوهیىيي‌ء")
}
