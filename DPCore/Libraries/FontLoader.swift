//
//  FontLoader.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/15/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import CoreText
import UIKit

private var loadedFontsTracker: [String: Bool] = ["IRANYekanLight": false,
                                                  "IRANYekanRegular": false,
                                                  "IRANYekanBold": false
]

internal class FontLoader {
    
    /**
     This utility function helps loading the font if not loaded already
     - Parameter fontType: The type of the font
     */
    static func loadFontIfNeeded() {
        
        for (fontName, value ) in loadedFontsTracker where value == false {
            
            let bundle = Bundle(for: FontLoader.self)
            var fontURL: URL!
            let identifier = bundle.bundleIdentifier
            
            fontURL = bundle.url(forResource: fontName, withExtension: "ttf")!
            
            guard let data = try? Data(contentsOf: fontURL) else { continue }
            
            let provider = CGDataProvider(data: data as CFData)
            let font = CGFont(provider!)!
            
            guard self.checkFontExisted(font, data) == false else {
                loadedFontsTracker[fontName] = true
                continue
            }
            
            var error: Unmanaged<CFError>?
            
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                
                let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
                print(nsError)
                NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
            }
            else {
                loadedFontsTracker[fontName] = true
                
            }
            
        }
    }
    
    private static var checkFontExisted = { (_ font: CGFont, _ data: Data) -> Bool in
        
        if let fontFamilyNames = FontLoader.fontFamilyNames,
            let fontFamilyName = FontLoader.fontFamilyName(data),
            UIFont.fontNames(forFamilyName: fontFamilyName).contains(font.postScriptName! as String) {
            return true
        }
        
        return false
    }
    
    private static var fontFamilyNames: [String]? {
        if #available(iOS 10.0, *) {
            return CTFontManagerCopyAvailableFontFamilyNames() as? [String]
        }
        else {
            return UIFont.familyNames
            // Fallback on earlier versions
        }
    }
    
    private static let fontDescriptor = { (_ data: Data) -> CTFontDescriptor? in
        return CTFontManagerCreateFontDescriptorFromData(data as CFData)
    }
    
    private static let fontFamilyName = { (_ data: Data) -> String? in
        guard let fontDescriptor = FontLoader.fontDescriptor(data) else { return nil }
        return CTFontDescriptorCopyAttribute(fontDescriptor, kCTFontFamilyNameAttribute) as? String
    }
    
}
