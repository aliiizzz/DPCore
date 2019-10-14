//
//  PinProtectionViewModel.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/6/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation
import UIKit

struct PinProtectionInput {
    
    let ticket: String
    let userId: String
    let feature: ProtectedFeatureKey
    let isRequired: Bool
    
    let completion: ((PinProtectionResult) -> Void)?
    
}

class PinProtectionViewModel: ViewModel {
    
    typealias Input = PinProtectionInput
    typealias Output = Bool
    typealias Service = PinProtectionService
    
    let isLoading: Observable<Bool> = Observable(false)
    let isVerifyPin: Observable<Bool?> = Observable(nil)
    
    var isMandetory: Bool {
        return inputValue.isRequired
    }
    
    let inputValue: Input
    
    func transform(input: Input) -> Bool {
        return false
    }
    weak var coordinator: PinProtectionCoordinator?
    
    init(input: Input, coordinator: Coordinator?) {
        self.inputValue = input
        self.coordinator = coordinator as? PinProtectionCoordinator
    }
    
    func verify(pin: String, completion: @escaping (_ isValid: Bool) -> Void) {
        
        guard !isLoading.value else {
            return
        }
        
        let data = PinRequestModel(username: inputValue.userId,
                                   password: pin,
                                   features: [inputValue.feature])
        
        let service = Service(ticket: inputValue.ticket, data: data)
        
        service
            .run(ignoreStatusCodes: [401, 403])
            .subscribeOn(queue: .main)
            .subscribe(onNext: {[weak self] (response) in
                completion(response.result.status == 0)
                self?.handle(response: response)
            }, onError: {[weak self] error in
                self?.handle(error: error)
                completion(false)
            },
              onErrorWithData: {[weak  self] (error, data) in
                    self?.handle(error: error, data: data as? PinVerifyResponse)
                    completion(false)
            })
        
    }
    
    func cancelledByUser() {
        
        let response = isMandetory ? GlobalResponse(status: .failure,
                                                         data: [:],
                                                         error: SDKError(message: "درخواست توسط کاربر لغو شد",
                                                                         code: SDKErrorCode.cancelledByUser.rawValue)) : nil
        
        coordinator?.navigate(to: .finish(result: .failure,
                                          response: response))
        inputValue.completion?(.failure)
    }
    
    private func handle(response: PinVerifyResponse) {
        
        self.isLoading.value = false
        self.isVerifyPin.value = response.result.status == 0
        
        guard response.result.status == 0 else {
            self.handle(error: NetworkResponse.failed, data: response)
            return
        }
        
        coordinator?.navigate(to: .finish(result: .success, response: nil))
        inputValue.completion?(.success)
    }
    
    private func handle(error: Error, data: PinVerifyResponse? = nil) {
        
        self.isLoading.value = false
        self.isVerifyPin.value = false
        
        guard let data = data else {
            
            if let error = error as? NetworkResponse {
                
                let response = GlobalResponse.init(status: .failure,
                                                   data: [:], error: error)
                inputValue.completion?(.failure)
                coordinator?.navigate(to: .finish(result: .failure, response:response))
                
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
            _ = SnackBar(title: data.result.message, actionTitle: nil, action: nil, timeInterval: 3)
//            snack.show()
        }
        else {
            let error = SDKError.init(message: data.result.message,
                                      code: SDKErrorCode.security.rawValue)
            let response = GlobalResponse.init(status: .failure,
                                               data: [:], error: error)
            inputValue.completion?(.failure)
            coordinator?.navigate(to: .finish(result: .failure, response:response))
        }
    }
    
}
