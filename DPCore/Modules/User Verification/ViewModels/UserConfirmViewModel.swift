//
//  UserConfirmViewModel.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/8/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

struct UserConfirmViewModelInput {
    
    let ticket: String
    let tacURL: URL
    let userDetail: UserDetail
    var features: [ProtectedFeatureKey]
    let isRequired: Bool
    
    var completion : (_ result: Bool) -> Void
    
}

struct UserConfirmViewModelOutput: UserOTPCodeInputable {
    
    let ticket: String
    let userDetail: UserDetail
    let isRequired: Bool
    var features: [ProtectedFeatureKey]
    
    var completion : (_ result: Bool) -> Void
}

final class UserConfirmViewModel: ViewModel {
    
    typealias Service = TACService
    typealias Input = UserConfirmViewModelInput
    typealias Output = UserOTPCodeInputable
    
    let input: Input
    
    let coordinator: UserVerificationCoordinator?
    
    var mobile: String {
        return input.userDetail.mobileNumber.persian
    }
    
    var isMandetory: Bool {
        return input.isRequired
    }
    
    init(input: Input, coordinator: Coordinator? = nil) {
        self.input = input
        self.coordinator = coordinator  as? UserVerificationCoordinator
    }
    
    func didAccpetTAC() {
        let output = transform(input: input)
        coordinator?.navigate(to: .userOTPCode(input: output))
    }
    
    func didCancelByUser() {
        
        let response = input.isRequired ? GlobalResponse(status: .failure,
            data: [:],
            error: SDKError(message: "درخواست توسط کاربر لغو شد",
            code: SDKErrorCode.cancelledByUser.rawValue)) : nil
        
        coordinator?.navigate(to: .finish(result: false, response: response))
        input.completion(false)
        
    }
    
    func didTapOnTerms() {
        coordinator?.navigate(to: .userTAC(url: input.tacURL))
    }
    
}

extension UserConfirmViewModel {
    func transform(input: Input) -> Output {
        return UserConfirmViewModelOutput(ticket: input.ticket,
                                          userDetail: input.userDetail,
                                          isRequired: input.isRequired,
                                          features: input.features,
                                          completion: input.completion)
    }
}
