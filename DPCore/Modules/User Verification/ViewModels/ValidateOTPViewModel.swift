//
//  ValidateOTPViewModel.swift
//  DPCore
//
//  Created by Amir Roudsari on 7/3/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

final class ValidateOTPViewModel: ViewModel {
    
    typealias Input = UserOTPCodeInputable
    typealias Output = AcceptTACOutput
    typealias Service = ValidateOTPService
    private let serivce: Service?
    
    let input: Input
    
    let mobileNumber: Observable<String>
    let isLoading: Observable<Bool> = Observable(false)
    let isVerifyCode: Observable<Bool?> = Observable(nil)
    let isEnableButton: Observable<Bool> = Observable(false)
    
    var isMandetory: Bool {
        return input.isRequired
    }
    
    weak var coordinator: UserVerificationCoordinator?
    
    init(input: Input, coordinator: Coordinator? = nil) {
        
        self.input = input
        self.coordinator = coordinator as? UserVerificationCoordinator
        self.mobileNumber = Observable(input.userDetail.mobileNumber.persian)
        self.serivce = Service(ticket: input.ticket)
        
    }
    
    func verifyCode(code: String, completion : @escaping (_ result: Bool, _ error: Error?) -> Void) {
        
        guard !isLoading.value else {
            return
        }
        
        self.isLoading.value = true
        self.serivce?.set(code: OtpValidationModel(code: code.digits.english, features: input.features))
        self.serivce?.run()
            .subscribeOn(queue: .main)
            .subscribe(onNext: {[weak self] (response) in
                self?.handle(response: response)
                completion(true, nil)
                }, onError: {[weak self] (error) in
                    self?.isLoading.value = false
                    completion(false, error)
                    self?.handle(error: error)
                }, onErrorWithData: {[weak self] (error, response) in
                    self?.isLoading.value = false
                    completion(false, error)
                    self?.handle(error: error, data: response as? OtpValidationResponse)
            })
        
    }
    
    func cancelledByUser() {
        
        let response = input.isRequired ? GlobalResponse(status: .failure,
                                                         data: [:],
                                                         error: SDKError(message: "درخواست توسط کاربر لغو شد",
                                                                         code: SDKErrorCode.cancelledByUser.rawValue)) : nil
        
        coordinator?.navigate(to: .finish(result: false, response: response))
        input.completion(false)
        
    }
    
    private func handle(response: OtpValidationResponse) {
        self.isLoading.value = false
        self.isVerifyCode.value = response.result.status == 0
        
        guard response.result.status == 0 else {
            //FIXME: called callback when result.status is not equal to zero
            coordinator?.navigate(to: .finish(result: false, response: nil))
            input.completion(false)
            return
        }
        
        coordinator?.navigate(to: .finish(result: true, response: nil))
        input.completion(true)
    }
    
    private func handle(error: Error, data: OtpValidationResponse? = nil) {
        
        self.isLoading.value = false
        self.isVerifyCode.value = false
        
        guard let data = data else {
            
            if let error = error as? NetworkResponse {
                
                let response = GlobalResponse.init(status: .failure,
                                                   data: [:], error: error)
                
                coordinator?.navigate(to: .finish(result: false, response:response))
                input.completion(false)
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
            let error = SDKError.init(message: data.result.message,
                                      code: SDKErrorCode.security.rawValue)
            let response = GlobalResponse.init(status: .failure,
                                               data: [:], error: error)
            
            coordinator?.navigate(to: .finish(result: false, response:response))
            input.completion(false)
        }
    }
    
}

extension ValidateOTPViewModel {
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension ValidateOTPViewModel: DigitInputViewDelegate {
    
    func digitsDidChange(digitInputView: DigitInputView) {
        isEnableButton.value = digitInputView.text.count >= 5
        if isEnableButton.value == false {
            isVerifyCode.value = nil
        }
        else {
            verifyCode(code: digitInputView.text.persian) { _, _ in
                
            }
        }
    }
    
    func configureDigit(digitView: DigitInputView, digit: String, at index: Int) -> String {
        return digit.persian
    }
    
    func didSetDigit(_ digitView: DigitInputView, at index: Int) {
        
    }
    
    func bind(digiInput: DigitInputView) {
        digiInput.delegate = self
    }
    
}
