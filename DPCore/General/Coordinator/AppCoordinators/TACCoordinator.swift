//
//  TACCoordinator.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-24.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

enum TACRoute: Route {
    
    case loading(ticket : String)
    case acceptingTAC(ticket:String, url: URL, tacResponse : TACResponse)
    case ipg(url : URL)
    case userVerification(data : UserConfirmViewModelInput)
    case pin(data:PinProtectionInput)
    case finish(result: Bool, data : TacMetaData?, response: GlobalResponse?)
    
}

final class TACCoordinator: BaseCoordinator<DPRouterNavigationController, TACRoute>, FinishableCoordinator {
    
    var finish: ((TACCoordinator) -> Void)?
    
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
    
    // MARK: - Override methods
    override func start(with route: TACRoute) {
        switch route {
        case .loading(let ticket):
            self.navigateToLoadingView(with: ticket, animated: false)
        case .acceptingTAC(let data):
            self.navigateToTACView(with: data, animated: false)
        case .userVerification(let data):
            navigateToUserVerification(data: data, animated: false)
        case .pin(let data):
            navigateToPinProtection(data: data, animated: false)
        default:
            break
        }
    }
    
    override func navigate(to route: TACRoute) {
        switch route {
        case .loading(let ticket):
            self.navigateToLoadingView(with: ticket)
            
        case .acceptingTAC(let data):
            self.navigateToTACView(with: data)
            
        case .ipg(let url):
            (self.parentCoordinator as? AppCoordinator)?.navigate(to: .openWebTerminal(url: url))
        case .userVerification(let data):
            navigateToUserVerification(data: data)
        case .pin(let data):
            navigateToPinProtection(data: data)
            
        case .finish(let result, let data, let response):
            
            guard result == false else {
                
                if let data = data {
                    (self.parentCoordinator as? AppCoordinator)?.navigate(to: .payment(metaData: data ))
                    self.finish?(self)
                }
                
                return
            }
            
            if let response = response {
                self.finish?(self)
                (self.parentCoordinator as? AppCoordinator)?.navigate(to: .dismiss(response: response))
            }
       
        }
    }
    
    private func navigateToLoadingView(with ticket: String, animated: Bool = true) {
        let viewController = viewControllerFactory.instanceOfLoadingViewController()
        let viewModel = LoadingViewModel(input: .init(ticket : ticket),
                                         coordinator: self)
        viewController.viewModel = viewModel
        
        router.push(viewController,
                    transition: nil,
                    animated: animated)
        
    }
    
    private func navigateToTACView(with data : (ticket: String, url: URL, tacResponse: TACResponse), animated: Bool = true) {
        let viewController = viewControllerFactory.instanceOfTACViewController()
        let input = AcceptTACInput(ticket: data.ticket,
                                   tacResponse: data.tacResponse,
                                   tacURL: data.url)
        let viewModel = AcceptTACViewModel(input: input)
        
        viewModel.coordinator = self
        viewController.viewModel = viewModel
        
        router.set(root: viewController, hideBar: false)
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
