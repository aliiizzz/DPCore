//
//  AcceptTACViewModel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-15.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

final class AcceptTACViewModel: ViewModel {
    
    typealias Input = AcceptTACInput
    typealias Output = AcceptTACOutput
    typealias Service = TACAcceptService
    
    private var serivce: Service?
    
    let isLoading: Observable<Bool> = Observable(false)
    let shouldAcceptTAC: Observable<Bool> = Observable(true)
    let dismissCallback: Observable<Void?> = Observable(())
    
    weak var coordinator: TACCoordinator?
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    let ticket: String
    let tacURL: URL
    let loadingTACResponse: TACResponse?
    
    deinit {
        coordinator = nil
    }
    
    init(ticket: String, tacURL: URL, shouldAcceptTAC: Bool = true) {
        self.ticket = ticket
        self.tacURL = tacURL
        self.loadingTACResponse = nil
        self.shouldAcceptTAC.value = shouldAcceptTAC
        self.serivce = TACAcceptService(ticket: ticket, tacURL: tacURL)
    }

    init(input: Input, shouldAcceptTAC: Bool = true) {
        self.ticket = input.ticket
        self.tacURL = input.tacURL
        self.loadingTACResponse = input.tacResponse
        
        self.shouldAcceptTAC.value = shouldAcceptTAC
        self.serivce = TACAcceptService(ticket: ticket, tacURL: tacURL)
    }
    
    func cancelledByUser() {
        
        let response = GlobalResponse(status: .failure,
                                      data: [:],
                                      error: SDKError(message: "درخواست توسط کاربر لغو شد", code: SDKErrorCode.cancelledByUser.rawValue))
        coordinator?.navigate(to: .finish(result: false, data:nil, response:response))
        
    }
    
    func dismissMe() {
        dismissCallback.value = ()
    }
    
    func runService() {
        
        guard !isLoading.value else {
            return
        }
        
        isLoading.value = true
        
        self.serivce?.run()
            .subscribeOn(queue: .main)
            .subscribe(onNext: {[weak self] result in
                self?.isLoading.value = false
                
                guard let result = self?.loadingTACResponse else {
                    return
                }
                
                self?.parseServerResponse(result: result) { _ in }
                }, onError: { [weak self] error in
                    self?.isLoading.value = false
                    self?.handle(error: error)
            }) {[weak self] error, data in
                self?.isLoading.value = false
                self?.handle(error: error, data: data as? TACResponse)
        }
        
    }
    
    // MARK: - Private Methods
    private func parseServerResponse(result: TACResponse, completion : @escaping (Bool) -> Void) {
        
        let ticket = self.ticket
        
        GlobalInput.metaData = result.metaData
        
        guard let coordinator = coordinator else {
            completion(false)
            return
        }
        
        if result.metaData?.gateways?.contains(.ipg) == true,
            result.metaData?.gateways?.count == 1 {
            
            navigateToIPGTerminal(metaData: result.metaData) {[weak self] result, response in
                
                self?.coordinator?.navigate(to: .finish(result: false, data:nil, response: response))
                
            }
            
            return
        }
        
        completion(true)
        
        let metaData = result.metaData
        
        navigateToPayment(metaData: metaData) {[weak self] result, response in
            self?.coordinator?.navigate(to: .finish(result: result, data:result ? metaData : nil, response: response))
        }
        
    }
    
    private func handle(error: Error, data: TACResponse? = nil) {
        
        guard let coordinator = coordinator else {
            return
        }
        
        guard let data = data else {
            
            if let error = error as? NetworkResponse {
                
                coordinator.navigate(to: .finish(result: false,
                                                 data:nil,
                                                 response: GlobalResponse(status: .failure, data: [:], error: error)))
                
            }
            else {
                
                var title = error.localizedDescription
                
                if let error = error as? URLError {
                    title = error.persianLocalizationError
                }
                
                let snack = SnackBar(title: title, actionTitle: nil, action: nil, timeInterval: 3)
                snack.show()
            }
            return
        }
        
        guard let level = data.result.level else { return }
        
        if level == .WARN || level == .INFO {
            let snack = SnackBar(title: data.result.message, actionTitle: nil, action: nil, timeInterval: 3)
            snack.show()
        }
        else {
            coordinator.navigate(to: .finish(result: false,
                                             data:nil,
                                             response: GlobalResponse(status: .failure, data: [:], error: error)))
            
        }
        
    }
    
    private typealias NavigationCompletion = (_ result: Bool, _ response: GlobalResponse?) -> Void
    
    private func navigateToPayment(metaData: TacMetaData?, completion: @escaping NavigationCompletion) {
        
        navigateToProtectionIfNeeded(with: metaData,
                                     featureKey: .SDKInfo) { result, _, response in
                                        
                                        guard result else {
                                            completion(result, response)
                                            return
                                        }
                                        
                                        completion(true, response)
        }
    }
    
    private func navigateToIPGTerminal(metaData: TacMetaData?, completion : @escaping NavigationCompletion) {
        
        let ticket = self.ticket
        navigateToProtectionIfNeeded(with: metaData,
                                     featureKey: .paymentIPG) {[weak self] result, feature, response in
                                        
                                        guard result,
                                            let feature = feature else {
                                                completion(result, response)
                                                return
                                        }
                                        
                                        self?.navigateTo(ipg: feature, ticket: ticket, completion: completion)
        }
        
    }
    
    private func navigateTo(ipg feature: FeatureModel, ticket: String, completion: @escaping NavigationCompletion) {
        
        guard let url = feature.url else {
            let response = GlobalResponse(status: .failure,
                                          data: [:],
                                          error: SDKError(message: "IPG url is not found.", code: SDKErrorCode.internal.rawValue))
            
            completion(false, response)
            return
        }
        
        let response = GlobalResponse(status: .failure,
                                      data: [:],
                                      error: SDKError(message: "redirect to IPG", code: SDKErrorCode.redirectToIPG.rawValue))
        completion(true, response)
        coordinator?.navigate(to: .ipg(url: url.appendingPathComponent(ticket)))
        
    }
    
    private typealias NavigationProtectionCompletion = (_ result: Bool, _ feature: FeatureModel?, _ response: GlobalResponse?) -> Void
    
    private func navigateToProtectionIfNeeded(with metaData: TacMetaData?,
                                              featureKey: ProtectedFeatureKey,
                                              completion : @escaping NavigationProtectionCompletion) {
        
        guard let metaData = metaData,
            let feature = metaData.features.first(where: { $0.key == featureKey })?.value else {
                
                let response = GlobalResponse.buildResponse(status: .failure,
                                                            data: [:],
                                                            error: (code: .internal, message: "\(featureKey) is not found."))
                completion(false, nil, response)
                return
        }
        
        guard let userDetail = metaData.userDetail else {
            //FIXME: when we have a user which does not registred in Digipay Application, what happened??
            let response = GlobalResponse.buildResponse(status: .failure,
                                                        data: [:],
                                                        error: (code: .internal, message: "UserDetail is not found."))
            
            completion(false, nil, response)
            return
        }
        
        guard feature.isProtected == .none else {
            let ticket = self.ticket
            self.navigateToProtection(feature: feature,
                                      featureKey: featureKey,
                                      userDetail: userDetail,
                                      ticket: ticket) {[weak self] (result) in
                                        
                                        guard result else {
                                            self?.cancelledByUser()
                                            return
                                        }
                                        
                                        completion(result, feature, nil)
            }
            
            return
        }
        
        completion(true, feature, nil)
    }
    
    private func navigateToProtection(feature: FeatureModel,
                                      featureKey: ProtectedFeatureKey,
                                      userDetail: UserDetail,
                                      ticket: String,
                                      completion:@escaping (Bool) -> Void) {
        
        switch feature.isProtected {
        case .inAppVerification, .otp:
            
            guard let tacURL = URL(string: GlobalInput.tacUrl) else { return }
            
            let confirm = UserConfirmViewModelInput(ticket: ticket,
                                                    tacURL: tacURL,
                                                    userDetail: userDetail,
                                                    features: [featureKey],
                                                    isRequired: true) { (result) in
                                                        completion(result)
            }
            
            coordinator?.navigate(to: .userVerification(data:confirm))
            
        case .pin:
            
            let protection = PinProtectionInput(ticket: ticket,
                                                userId: userDetail.userId,
                                                feature: featureKey,
                                                isRequired: true) { result in
                                                    completion(result == .success)
            }
            
            coordinator?.navigate(to: .pin(data: protection))
        case .none:
            break
        }
    }
}
