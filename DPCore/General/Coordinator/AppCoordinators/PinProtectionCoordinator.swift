//
//  PinProtectionCoordinator.swift
//  DPCore
//
//  Created by Farshad Mousalou on 6/26/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

internal enum PinProtectionResult {
    case success
    case failure
}

enum PinProtectionRoute: Route {
    case pin(data : PinProtectionInput)
    case finish(result : PinProtectionResult, response : GlobalResponse?)
}

final class PinProtectionCoordinator: BaseCoordinator<DPRouterNavigationController, PinProtectionRoute>, FinishableCoordinator {
    
    var finish: ((PinProtectionCoordinator) -> Void)?
    
    deinit {
        finish = nil
    }
    
    // MARK: - Vars & Lets
    
    private let viewControllerFactory: ViewControllerFactory
    
    init(router: Router<DPRouterNavigationController> = Router(rootViewController: DPRouterNavigationController()),
         viewControllerFactory: ViewControllerFactory) {
        
        self.viewControllerFactory = viewControllerFactory
        super.init(router: router)
    }
    
    override func start(with route: PinProtectionRoute) {
        switch route {
        case .pin(let data):
             presentPinProtection(pinData: data, animated: false)
        default:
            break
        }
    }
    
    override func navigate(to route: PinProtectionRoute) {
        switch route {
        case .pin(let data):
            presentPinProtection(pinData: data)
        case .finish(let result, let response):
            
            self.router.dismiss(animated: true,
                                completion: {[weak self] in
                                    
                                    guard let strongSelf = self else { return }
                                    
                                    strongSelf.navigateToParentCoordinator(result: result,
                                                                data: response)
                                    strongSelf.finish?(strongSelf)
            })
            
        }
    }
    
    private func presentPinProtection(pinData: PinProtectionInput, animated: Bool = true) {
        let vc = self.viewControllerFactory.instanceOfPinProtectionViewController()
        let viewModel = PinProtectionViewModel(input: pinData, coordinator: self)
        vc.viewModel = viewModel
        
        router.set(root: vc, hideBar: false)
        
    }
    
    private func navigateToParentCoordinator(result: PinProtectionResult, data: GlobalResponse?) {
        
        guard let data = data, data.status == .failure else {
            return
        }
        
        guard let coordiantor = parentCoordinator else {
            return
        }
        
        switch coordiantor {
        case let coordinator as TACCoordinator:
            coordinator.navigate(to: .finish(result: false,
                                             data: nil, response: data))
        case let coordinator as AppCoordinator:
            coordinator.navigate(to: .dismiss(response: data))
        case let coordinator as PaymentCoordinator:
            coordinator.navigate(to: .finish(result: false,
                                             data: nil, response: data))
        default:
            break
        }
    }
    
}
