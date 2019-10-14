//
//  DeviceCodeName.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia case 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

enum DeviceCode: String {
    case simulator = "x86_64"
    case iPhone = "iPhone1,1"
    case iPhone3G = "iPhone1,2"
    case iPhone3GS = "iPhone2,1"
    case iPhone4_GSM = "iPhone3,1"
    case iPhone_4_CDMA_Verizon_Sprint = "iPhone3,3"
    case iPhone4S = "iPhone4,1"
    case iPhone5_model_A1428_ATT_Canada = "iPhone5,1"
    case iPhone5_model_A1429_everything_else = "iPhone5,2"
    case iPhone5c_model_A1456_A1532_GSM = "iPhone5,3"
    case iPhone5c_model_A1507_A1516_A1526_China_A1529_Global = "iPhone5,4"
    case iPhone5s_model_A1433_A1533_GSM = "iPhone6,1"
    case iPhone5s_model_A1457_A1518_A1528_China_A1530_Global = "iPhone6,2"
    case iPhone6_Plus = "iPhone7,1"
    case iPhone6 = "iPhone7,2"
    case iPhone6S = "iPhone8,1"
    case iPhone6S_Plus = "iPhone8,2"
    case iPhoneSE = "iPhone8,4"
    case iPhone7_CDMA = "iPhone9,1"
    case iPhone7_GSM = "iPhone9,3"
    case iPhone7_Plus_CDMA = "iPhone9,2"
    case iPhone7_Plus_GSM = "iPhone9,4"
    case iPhone8_CDMA = "iPhone10,1"
    case iPhone8_GSM = "iPhone10,4"
    case iPhone8_Plus_CDMA = "iPhone10,2"
    case iPhone8_Plus_GSM = "iPhone10,5"
    case iPhoneX_CDMA = "iPhone10,3"
    case iPhoneX_GSM = "iPhone10,6"
    case iPhoneXS = "iPhone11,2"
    case iPhoneXS_Max = "iPhone11,4"
    case iPhoneXS_Max_China = "iPhone11,6"
    case iPhoneXR = "iPhone11,8"
    
    var description: String {
        switch self {
        case .simulator:
            return "Simulator"
        case .iPhone:
            return "iPhone"
        case .iPhone3G:
            return "iPhone 3G"
        case .iPhone3GS:
            return "iPhone 3GS"
        case .iPhone4_GSM:
            return "iPhone 4 GSM"
        case .iPhone_4_CDMA_Verizon_Sprint:
            return "iPhone 4 CDMA (Verizon/Sprint)"
        case .iPhone4S:
            return "iPhone 4S"
        case .iPhone5_model_A1428_ATT_Canada:
            return " iPhone 5 model A1428 (AT&T Canada)"
        case .iPhone5_model_A1429_everything_else:
            return "iPhone 5 model A1429 everything else"
        case .iPhone5c_model_A1456_A1532_GSM:
            return "iPhone 5c model A1456 A1532 GSM"
        case .iPhone5c_model_A1507_A1516_A1526_China_A1529_Global:
            return "iPhone 5c model A1507, A1516, A1526, China, A1529, Global"
        case .iPhone5s_model_A1433_A1533_GSM:
            return "iPhone 5s model A1433 A1533 GSM"
        case .iPhone5s_model_A1457_A1518_A1528_China_A1530_Global:
            return "iPhone 5s model A1457 A1518 A1528 China A1530 Global"
        case .iPhone6_Plus:
            return "iPhone 6 Plus"
        case .iPhone6:
            return "iPhone 6"
        case .iPhone6S:
            return "iPhone 6S"
        case .iPhone6S_Plus:
            return "iPhone 6S Plus"
        case .iPhoneSE:
            return "iPhone SE"
        case .iPhone7_CDMA:
            return "iPhone 7 CDMA"
        case .iPhone7_GSM:
            return "iPhone 7 GSM"
        case .iPhone7_Plus_CDMA:
            return "iPhone 7 Plus CDMA"
        case .iPhone7_Plus_GSM:
            return "iPhone 7 Plus GSM"
        case .iPhone8_CDMA:
            return "iPhone 8 CDMA"
        case .iPhone8_GSM:
            return "iPhone 8 GSM"
        case .iPhone8_Plus_CDMA:
            return "iPhone 8 Plus CDMA"
        case .iPhone8_Plus_GSM:
            return "iPhone 8 Plus GSM"
        case .iPhoneX_CDMA:
            return "iPhone X CDMA"
        case .iPhoneX_GSM:
            return "iPhone X GSM"
        case .iPhoneXS:
            return "iPhone XS"
        case .iPhoneXS_Max:
            return "iPhone XS Max"
        case .iPhoneXS_Max_China:
            return "iPhone XS Max China"
        case .iPhoneXR:
            return "iPhone XR"
            
        }
    }
}
