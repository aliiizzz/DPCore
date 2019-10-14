//
//  UserVerificationCoordinator.swift
//  DPCore
//
//  Created by Farshad Mousalou on 6/26/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

enum UserVerificationRoute: Route {
    case userConfirm(input : UserConfirmViewModelInput)
    case userOTPCode(input : UserOTPCodeInputable)
    case userTAC(url : URL)
    case finish(result:Bool, response : GlobalResponse?)
}

final class UserVerificationCoordinator: BaseCoordinator<DPRouterNavigationController, UserVerificationRoute>, FinishableCoordinator {
    
    var finish: ((UserVerificationCoordinator) -> Void)?
    var disposeBag = Disposal()
    
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
    
    override func start(with route: UserVerificationRoute) {
        switch route {
        case .userConfirm(let input):
            self.navigateToUserVerification(input: input, animated: false)
        case .userOTPCode(let data):
            self.naviateToUserOTPCode(input: data, animated: false)
        case .userTAC(url: _):
            break
        case .finish(result: let result, response: let response):
            printDebug(result, response ?? "")
        }
    }
    
    override func navigate(to route: UserVerificationRoute) {
        switch route {
        case .userConfirm(let input):
            self.navigateToUserVerification(input: input)
        case .userOTPCode(let data):
            self.naviateToUserOTPCode(input: data)
        case .userTAC(url: let url):
            self.navigateToTAC(url: url)
        case .finish(result: let result, response: let response):
//            navigateToParentCoordinator(result: result,
//                                        data: response)
//            self.finish?(self)
            self.router.dismiss(animated: true,
                                completion: { [weak self] in 
                                    guard let strongSelf = self else { return }
                                    
                                    strongSelf.navigateToParentCoordinator(result: result,
                                                                           data: response)
                                    strongSelf.finish?(strongSelf)
            })
        }
    }
    
    private func navigateToUserVerification(input: UserConfirmViewModelInput, animated: Bool = true) {
        let vc = self.viewControllerFactory.instanceOfUserVerificationViewController()
        let viewModel = UserConfirmViewModel(input: input,
                                             coordinator: self)
        
        vc.viewModel = viewModel
        
        (router.viewController as? DPRouterNavigationController)?.isNavigationBarHidden = true
        router.push(vc, transition: nil, animated: animated)
    }
    
    private func naviateToUserOTPCode(input: UserOTPCodeInputable, animated: Bool = true) {
        
        let vc = self.viewControllerFactory.instanceOfUserVerficiationOTPCodeViewController()
        
        let sendOtpVM = SendUserOtpViewModel(input: input,
                                             coordinator: self)
        let validateOTPVM = ValidateOTPViewModel(input: input, coordinator: self)
        
        vc.sendOtpViewModel = sendOtpVM
        vc.validateOTPViewModel = validateOTPVM
        
        router.push(vc, transition: nil, animated: true)
    }
    
    private func navigateToTAC(url: URL, animated: Bool = true) {
        
        let vc = self.viewControllerFactory.instanceOfTACViewController()
        let rootVC = DPRouterNavigationController(rootViewController: vc)
        vc.viewModel = AcceptTACViewModel(ticket: "",
                                          tacURL: url, shouldAcceptTAC: false)
        
        vc.viewModel?
            .dismissCallback
            .skipFirst()
            .observer(on: .main)
            .observe({[weak self] (_, _) in
                self?.router.dismiss(animated: true, completion: {
                    
                })
            }).add(to: &disposeBag)
        
        router.present(rootVC, animated: animated)
    }
    
    private func navigateToParentCoordinator(result: Bool, data: GlobalResponse?) {
        
        guard let data = data, data.status == .failure else {
            return
        }
        
        guard let coordiantor = parentCoordinator else {
            return
        }
        
        switch coordiantor {
        case let coordinator as TACCoordinator:
            coordinator.navigate(to: .finish(result: result,
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
