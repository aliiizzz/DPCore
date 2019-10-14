//
//  ViewControllerFactory.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-24.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

internal final class ViewControllerFactory {
    
    internal func instanceOfTACViewController<T: TACViewController>() -> T {
        let vc = UIStoryboard.viewController(identifier: String(describing: "TACViewController")) as T
        return vc
    }
    
    internal func instanceOfPaymentViewController<T: PaymentViewController>() -> T {
        let vc = UIStoryboard.viewController(identifier: String(describing: "PaymentViewController")) as T
        return vc
    }
    
    internal func instanceOfLoadingViewController<T: LoadingViewController>() -> T {
        let vc = UIStoryboard.viewController(identifier: String(describing: "LoadingViewController")) as T
        return vc
    }
    
    internal func instanceOfReceiptViewController<T: ReceiptViewController>() -> T {
        let vc = UIStoryboard.viewController(identifier: String(describing: "ReceiptViewController")) as T
        return vc
    }
    
    internal func instanceOfPinProtectionViewController<T: PinProtectionViewController> () -> T {
        let vc = UIStoryboard.viewController(identifier: String(describing: "PinProtectionViewController")) as T
        return vc
    }
    
    internal func instanceOfUserVerificationViewController<T: UserConfirmViewController> () -> T {
        let vc = UIStoryboard.viewController(identifier: String(describing: "UserVerificationViewController")) as T
        return vc
    }
    
    internal func instanceOfUserVerficiationOTPCodeViewController <T: UserOTPViewController> () -> T {
        let vc = UIStoryboard.viewController(identifier: String(describing: "UserVerficationOTPCodeViewController")) as T
        return vc
    }
}
