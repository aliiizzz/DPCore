//
//  PaymentCoordinator.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-24.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

enum PaymentRoute: Route {
    case root(data : TacMetaData)
    case ipg(url : URL)
    case userVerification(data : UserConfirmViewModelInput)
    case pin(data:PinProtectionInput)
    case finish(result : Bool, data : ReceiptInput?, response : GlobalResponse?)
}

final class PaymentCoordinator: BaseCoordinator<DPRouterNavigationController, PaymentRoute>, FinishableCoordinator {
    
    var finish: ((PaymentCoordinator) -> Void)?
    
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
    
    override func start(with route: PaymentRoute) {
        switch route {
        case .root(let data):
            self.navigateToPaymentView(data: data, animated: false)
        case .userVerification(let data):
            navigateToUserVerification(data: data, animated: false)
        case .pin(let data):
            navigateToPinProtection(data: data, animated: false)
        default:
            break
        }
    }
    
    override func navigate(to route: PaymentRoute) {
        switch route {
        case .root(let data):
            printDebug("\(route)")
            self.navigateToPaymentView(data: data)
        case .ipg(url:let url):
            (parentCoordinator as? AppCoordinator)?
                .navigate(to: .openWebTerminal(url: url))
        case .userVerification(let data):
            navigateToUserVerification(data: data)
        case .pin(let input):
            navigateToPinProtection(data: input)
        case .finish(let result, let data, let response):
            
            self.router.viewController?.enableInteraction()
            
            guard result else {
                
                if let response = response {
                    (parentCoordinator as? AppCoordinator)?.navigate(to: .dismiss(response: response))
                }
                
                self.finish?(self)
                return
            }
            
            self.finish?(self)
            if let data = data {
                (parentCoordinator as? AppCoordinator)?.navigate(to: .reciept(input: data))
            }
            
        }
    }
    
    private func navigateToPaymentView(data: TacMetaData, animated: Bool = true) {
        
        let vc = self.viewControllerFactory.instanceOfPaymentViewController()
        
        let ticket = GlobalInput.ticket
        
        let cardsViewModel = PaymentBankCardListViewModel(ticket: ticket)
        let bankViewModel = PaymentBankListViewModel(ticket: ticket)
        
        vc.viewModel = PaymentViewModel(data: data,
                                        ticket: ticket,
                                        bankCardListViewModel: cardsViewModel,
                                        bankListViewModel: bankViewModel)
        
        self.router.set(root: vc, hideBar: false)
        
        vc.viewModel?.coordinator = self
    }
    
    private func navigateToPinProtection(data: PinProtectionInput, animated: Bool = true) {
        
        let coordinator = PinProtectionCoordinator(viewControllerFactory: viewControllerFactory)
        
        coordinator.finish = { [weak self] coordinator in
            
            defer {
                coordinator.finish = nil
            }
            
            guard let strongSelf = self else { return }
            
            strongSelf.remove(coordinator)
            
        }
        
        coordinator.start(with: .pin(data: data))
        coordinator.parentCoordinator = self
        
        self.add(coordinator)
        self.router.present(coordinator, animated: animated)
    }
    
    private func navigateToUserVerification(data: UserConfirmViewModelInput, animated: Bool = true ) {
        
        let coordinator = UserVerificationCoordinator(viewControllerFactory: viewControllerFactory)
        
        coordinator.finish = { [weak self] coordinator in
            
            defer {
                coordinator.finish = nil
            }
            
            guard let strongSelf = self else { return }
            
            strongSelf.remove(coordinator)
            
        }
        
        coordinator.start(with: .userConfirm(input: data))
        coordinator.parentCoordinator = self
        
        self.add(coordinator)
        self.router.present(coordinator, animated: animated)
    }
}
