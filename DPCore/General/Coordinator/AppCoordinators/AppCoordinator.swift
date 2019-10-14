//
//  AppCoordinator.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-24.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

enum SDKRoute: Route {
    case tac(ticket : String)
    case payment(metaData: TacMetaData)
    case openWebTerminal(url : URL)
    case reciept(input : ReceiptInput)
    case dismiss(response : GlobalResponse)
}

class AppCoordinator: BaseCoordinator<DPRouterNavigationController, SDKRoute> {
    
    private let viewControllerFactory: ViewControllerFactory = ViewControllerFactory()
    
    let shouldSkipLoading: Bool
    
    deinit {
        
        (router.viewController as? UINavigationController)?.viewControllers.removeAll()
        
    }
    
    // MARK: - Constructors
    required init(router: Router<DPRouterNavigationController>,
                  shouldSkipLoadingView: Bool = false) {
        
        self.shouldSkipLoading = shouldSkipLoadingView && (Bundle.main.bundleIdentifier?.contains("com.mydigipay.app.ios") == true)
        super.init(router: router)
        FontLoader.loadFontIfNeeded()
        
    }
    
    override func start(with route: SDKRoute) {
        switch route {
        case .tac(let ticket):
            self.navigateToTACRoute(with: ticket, animated: false)
        case .payment(let metaData):
            self.navigateToPaymentRoute(with: metaData, animated: false)
        case .reciept(let receipt):
            self.navigateToReceiptRoute(with: receipt, animated: false)
        default:
            break
        }
    }
    
    override func navigate(to route: SDKRoute) {
        
        switch route {
        case .tac(let ticket):
            self.navigateToTACRoute(with: ticket)
        case .payment(let ticketInfo):
            self.navigateToPaymentRoute(with: ticketInfo)
        case .reciept(let receipt):
            self.navigateToReceiptRoute(with: receipt)
        case .openWebTerminal(url : let url) :
            self.navigateToBrower(url: url)
        case .dismiss(response: let response):
            
            self.router.viewController?.enableInteraction()
            self.router.dismiss(animated: true) {
                
                var error = response.error
                if let networkError = response.error as? NetworkResponse {
                    error = networkError.sdkError
                }
                
                GlobalInput.status(response.status, response.data, error)
            }
            
        }
        
    }
    
    private func navigateToTACRoute(with ticket: String, animated: Bool = true) {
        
        let coordinator = TACCoordinator(router: router,
                                         viewControllerFactory: viewControllerFactory)
        
        coordinator.finish = { [weak self] coordinator in
            
            defer {
                coordinator.finish = nil
            }
            
            guard let strongSelf = self else { return }
            
            strongSelf.remove(coordinator)
            
        }
        
        coordinator.start(with: .loading(ticket: ticket))
        coordinator.parentCoordinator = self
        
        self.add(coordinator)
        
        self.router.push(coordinator,
                         transition: nil, animated: animated) { (_) in
                            
        }
        
    }
    
    private func navigateToPaymentRoute(with metaData: TacMetaData, animated: Bool = true) {
        
        let coordinator = PaymentCoordinator(router: router,
                                             viewControllerFactory: viewControllerFactory)
        
        coordinator.finish = { [weak self] coordinator in
            
            defer {
                coordinator.finish = nil
            }
            
            guard let strongSelf = self else { return }
            
            strongSelf.remove(coordinator)
            
        }
        
        coordinator.start(with: .root(data: metaData))
        coordinator.parentCoordinator = self
        
        self.add(coordinator)
        
        self.router.push(coordinator,
                         transition: nil, animated: animated) { (_) in
                            
        }
        
    }
    
    private func navigateToReceiptRoute(with receipt: ReceiptInput, animated: Bool = true) {
        
        let coordinator = ReceiptCoordinator(router: router,
                                             viewControllerFactory: viewControllerFactory)
        
        coordinator.finish = { [weak self] coordinator in
            
            defer {
                coordinator.finish = nil
            }
            
            guard let strongSelf = self else { return }
            
            strongSelf.remove(coordinator)
            
        }
        
        self.add(coordinator)
        
        coordinator.parentCoordinator = self
        coordinator.start(with: .root(receipt: receipt))
        
//        self.router.push(coordinator,
//                         transition: nil, animated: animated) { (_) in
//
//        }
    }
    
    private func navigateToBrower(url: URL) {
        
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.openURL(url)
        
    }
    
}
