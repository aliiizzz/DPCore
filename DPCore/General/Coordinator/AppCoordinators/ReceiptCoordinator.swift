//
//  ReceiptCoordinator.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-21.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

enum ReceiptRoute: Route {
    case root(receipt : ReceiptInput)
    case finish(result : Bool, response : GlobalResponse)
}

final class ReceiptCoordinator: BaseCoordinator<DPRouterNavigationController, ReceiptRoute>, FinishableCoordinator {
    
    var finish: ((ReceiptCoordinator) -> Void)?
    
    // MARK: - Vars & Lets
    
    private let viewControllerFactory: ViewControllerFactory
    
    deinit {
        finish = nil
    }
    
    init(router: Router<DPRouterNavigationController>,
         viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory
        super.init(router: router)
    }
    
    override func start(with route: ReceiptRoute) {
        navigate(to: route)
    }
    
    override func navigate(to route: ReceiptRoute) {
        switch route {
        case .root(let receipt):
            self.navigateToReceiptView(receipt)
        case .finish(_, let response):
            (parentCoordinator as? AppCoordinator)?.navigate(to: .dismiss(response: response))
            self.finish?(self)
        }
    }
    
    private func navigateToReceiptView(_ data: ReceiptInput) {
        
        let vc = self.viewControllerFactory.instanceOfReceiptViewController()
        
        vc.dismissHandler = { [weak self] data in
            
            self?.navigate(to: .finish(result: data.status == .success ? true :  false, response: data))
        }
        
        vc.receipt = data
        
        self.router.set(root: vc, hideBar: true)
    }
    
}
