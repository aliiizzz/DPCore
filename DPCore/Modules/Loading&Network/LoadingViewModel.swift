//
//  LoadingViewModel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-31.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit

typealias closure = () -> Void

//TODO: refactor and make clean code and remove dublication in code for protection feature

final class LoadingViewModel: ViewModel {
    
    typealias Input = LoadingInput
    typealias Output = LoadingOutput
    typealias Service = TACService
    
    private let input: Input
    private var reachability: Reachability?
    private let loadingService: Service
    
    let isLoading: Observable<Bool>
    let isPending: Observable<Bool> = Observable(false)
    
    weak var coordinator: TACCoordinator?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
        reachability = nil
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    init(input: Input, coordinator: TACCoordinator? = nil) {
        
        self.input = input
        self.isLoading = Observable(false)
        self.coordinator = coordinator
        
        loadingService = Service(ticket: input.ticket)
        
        self.reachability = Reachability()!
        
    }
    
    func cancelledByUser() {
        let response = GlobalResponse(status: .failure,
                                      data: [:],
                                      error: SDKError(message: "درخواست توسط کاربر لغو شد", code: SDKErrorCode.cancelledByUser.rawValue))
        coordinator?.navigate(to: .finish(result: false, data: nil, response:response))
    }
    
    func fetchDataFromServer(completion : @escaping (Bool, Error?) -> Void) {
        
        // check the request already send or not
        guard isLoading.value == false else {
            return
        }
        
        self.isLoading.value = true
        loadingService
            .run()
            .subscribeOn(queue: .main)
            .subscribe(onNext: {[weak self] result in
                
                    self?.isLoading.value = false
                    self?.isPending.value = true
                    self?.parseServerResponse(result: result) { result in
                        completion(result, nil)
                    }
                }, onError: { [weak self] error in
                        self?.isLoading.value = false
                        self?.handle(error: error)
                        completion(false, error)
            }) {[weak self] error, data in
                self?.isLoading.value = false
                self?.handle(error: error, data: data as? TACResponse)
        }
    }
    
    // MARK: - Private Methods
    private func parseServerResponse(result: TACResponse, completion : @escaping (Bool) -> Void) {
        
        let ticket = self.input.ticket
        
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
        
        if result.shouldAcceptTac == true {
            GlobalInput.tacUrl = result.tacUrl ?? "https://www.mydigipay.com/404.html"
            
            if let url = URL(string: result.tacUrl ?? "https://www.mydigipay.com/404.html") {
                coordinator.navigate(to: .acceptingTAC(ticket: ticket,
                                                       url: url,
                                                       tacResponse: result))
            }
        }
        else {
            
            GlobalInput.tacUrl = result.tacUrl ?? "https://www.mydigipay.com/404.html"
            
            let tacURL = result.tacUrl
            let metaData = result.metaData
            
            navigateToPayment(metaData: metaData) {[weak self] result, response in
                
                if let url = URL(string: tacURL ?? "https://www.mydigipay.com/404.html"),
                    result == true {
                    AcceptTACViewModel(ticket: ticket, tacURL: url).runService()
                }
                
                self?.coordinator?.navigate(to: .finish(result: result, data:result ? metaData : nil, response: response))
            }
        }
        
    }
    
    private func handle(error: Error, data: TACResponse? = nil) {
        
        guard let error = error as? NetworkResponse, error != .badRequest else {
            return
        }
        
        guard let coordinator = coordinator else {
            return
        }
        
        coordinator.navigate(to: .finish(result: false,
                                         data:nil,
                                         response: GlobalResponse(status: .failure, data: [:], error: error)))
        
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
        
        let ticket = input.ticket
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
            let ticket = input.ticket
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

fileprivate extension LoadingViewModel {
    
    @objc func reachabilityChanged(value: Notification) {
        guard let reachability = value.object as? Reachability else { return }
        changeState(reachability)
    }
    
    func changeState(_ reachability: Reachability?) {
        
        guard let reachability = reachability else { return }
        
        if reachability.connection != .none {
            self.isLoading.value = true
        }
        else {
            self.isLoading.value = false
        }
    }
    
    func startNotify() {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(reachabilityChanged(value:)),
                         name: .reachabilityChanged,
                         object: reachability)
        
        do {
            try reachability?.startNotifier()
        }
        catch {
            fatalError("cant start reachability services")
        }
    }
    
    func stopNotify() {
        reachability?.stopNotifier()
    }
    
}

struct LoadingInput {
    let ticket: String
    
}

struct LoadingOutput {
    
}
