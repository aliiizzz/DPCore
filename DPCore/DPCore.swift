//
//  DPCore.swift
//  DPCore
//
//  Created by Amir Hesam Rayatnia on 2018-10-10.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit

typealias responseTypes = ((DPStatus, [String: Any], Error?) -> Void)

/// <#Description#>
///
/// - success: Return when the payment operation was successful.
/// - failure: Return when the operation occured error. 
@objc(DPCoreStatus)
public enum DPStatus: Int {
    case success
    case failure
}

/// SDK Error Code Enum
///
/// - `internal`: Returned when the payment request operation failed in SDK
/// - cancelledByUser: The user cancelled the operation (for example, by pressing cancel in Payment Operation).
/// - timedOut: Returned when an payment request operation times out.
/// - cannotConnectToHost: Returned when an attempt to connect to a Server has failed.
/// - redirectToIPG : Return when sdk does not response to request operation.
/// - redirectToIPG : Return when the payment operation meet security error
@objc(SDKErrorCode)
public enum SDKErrorCode: Int {
    
    /// Returned when the payment request operation failed in SDK
    case `internal` =  -1
    
    /// The user cancelled the operation (for example, by pressing cancel in Payment Operation).
    case cancelledByUser = -2
    
    /// Returned when an payment request operation times out.
    case timedOut = -3
    
    /// Returned when an attempt to connect to a Server has failed.
    case cannotConnectToHost = -4
    
    /// Return when sdk does not response to request operation.
    case redirectToIPG = -5
    
    /// Return when the payment operation meet security error
    case security = -6
}

@objc(DPCoreResult)
/// <#Description#>
public class DPCoreResult: NSObject {

    @objc private(set) var trackingCode: String!
    @objc private(set) var date: Date!
    @objc private(set) var rrnCode: String?
    @objc private(set) var paymentResult: Int
    
    override public init() {
        self.paymentResult = -1
        super.init()
    }
    
    internal convenience init(trackingCode: String, date: Date, rrnCode: String? = nil, paymentResult: Int) {
        self.init()
        self.trackingCode = trackingCode
        self.date = date
        self.rrnCode = rrnCode
        self.paymentResult = paymentResult
    }

}

/// <#Description#>
@objc public final class DPCore: NSObject {
    
    /// <#Description#>
    @objc public class final func application(_ app: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
    }
    
    private static var coordinator: AppCoordinator?
    
    @objc
    private dynamic static var skipLoadingView: Bool = false
    
    /// - parameter view: UIViewController ~> which help us to keep payment view in host view hierarchy
    /// - parameter ticket: String ~> it's user payment's ticket which means the id of the basket(in DigiPay) he/she want to pay it.
    /// - parameter mode: DPMode ~> it helps you to switch between payment and top up payment
    /// - parameter completion: (DPStatus, [String:Any],Error)->Void ~> this method is an callback which help you to get the response
    /// of payment
    @objc public class final func payment(view: UIViewController, ticket: String, completion: @escaping ((DPStatus, [String: Any], Error?) -> Void)) {
        
        let navigationController = DPRouterNavigationController()
        //vc.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "IRANYekan", size: 18)]
        navigationController.navigationBar.backgroundColor = .white
        navigationController.view.backgroundColor = .white
        navigationController.isNavigationBarHidden = true
        
        debugPrint("API => ", SDKSetting.PRODUCTION_URL)
        
        let router = Router<DPRouterNavigationController>(rootViewController: navigationController)
        printDebug(self.skipLoadingView)
        
        let coordinator: AppCoordinator = AppCoordinator(router: router,
                                                         shouldSkipLoadingView: self.skipLoadingView)
        
        coordinator.start(with: .tac(ticket: ticket))
        DPCore.coordinator = coordinator
        
        GlobalInput.status = { (status, data, error) in
            
            guard let coordinator = DPCore.coordinator else { return }
            
            defer {
                DPCore.coordinator = nil
            }
            
            GlobalInput.status = nil
            completion(status, data, error)
            
        }
        
        GlobalInput.ticket = ticket
        
        guard let vc = router.viewController else {
            fatalError("default router dont contain view controller")
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            vc.modalPresentationStyle = .formSheet
            vc.preferredContentSize = CGSize(width: 375, height: 548+64)
        }
        
        view.present(vc, animated: true, completion: {
            
        })
       
    }
    
    public override init() {}
}
