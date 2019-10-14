//
//  SendUserOtpViewModel.swift
//  DPCore
//
//  Created by Amir Roudsari on 7/3/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

final class SendUserOtpViewModel: ViewModel {
    
    typealias Input = UserOTPCodeInputable
    typealias Output = Bool
    typealias Service = SendOTPService
    private let serivce: Service?
    
    let input: Input
    
    let mobileNumber: Observable<String>
    let isLoading: Observable<Bool> = Observable(false)
    let isEnabledSendCode: Observable<Bool> = Observable(false)
    let remainingTime: Observable<String> = Observable("")
    
    private var timer: Timer?
    
    private let formatter: DateComponentsFormatter = {
        var calender = Calendar.current
        calender.locale = Locale(identifier: "fa-IR")
        let formatter = DateComponentsFormatter()
        formatter.calendar = calender
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.allowsFractionalUnits = true
        return formatter
    }()
    
    weak var coordinator: UserVerificationCoordinator?
    
    init(input: Input, coordinator: Coordinator? = nil) {
        
        self.input = input
        self.coordinator = coordinator as? UserVerificationCoordinator
        self.mobileNumber = Observable(input.userDetail.mobileNumber.persian)
        self.serivce = Service(ticket: input.ticket)
        
    }
    
    func sendUserOTP(completion : @escaping (_ result: Bool, _ error: Error?) -> Void) {
        
        guard !isLoading.value else {
            return
        }
        
        isLoading.value = true
        isEnabledSendCode.value = false
        
//        #if DEBUG
//            guard false else {
//                isLoading.value = false
//                triggleTimer()
//                return
//            }
//        #endif
        
        serivce?.run().subscribeOn(queue: .main)
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
                self?.handle(error: error, data: response as? OtpRequestResponse)
            })
        
    }
    
    func cancelledByUser() {
        
    }
    
    private func handle(response: OtpRequestResponse) {
        isLoading.value = false
        guard response.result.status == 0 else {
            //FIXME: called callback when result.status is not equal to zero
            coordinator?.navigate(to: .finish(result: false, response: nil))
            return
        }
        
        triggleTimer()
        
    }
    
    private func handle(error: Error, data: OtpRequestResponse? = nil) {
        
        self.isLoading.value = false
        self.isEnabledSendCode.value = true
        
        guard let data = data else {
            
            if let error = error as? NetworkResponse {
                
                let response = GlobalResponse.init(status: .failure,
                                                   data: [:], error: error)
                input.completion(false)
                coordinator?.navigate(to: .finish(result: true, response:response))
                
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
            input.completion(false)
            coordinator?.navigate(to: .finish(result: true, response:response))
        }
    }
    
}

fileprivate extension SendUserOtpViewModel {
    
    func triggleTimer() {
        
        if let timer = timer, timer.isValid {
            timer.invalidate()
        }
        
        if timer == nil {
            
            #if DEBUG
                let finishTimeInterval = 15
            #else
                let finishTimeInterval = 120
            #endif
            
            let startTime: Int = Int(Date().timeIntervalSince1970)
            let finishTime: Int = startTime + finishTimeInterval
            
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self, selector: #selector(timerIntervalHandler(_:)),
                                         userInfo: finishTime, repeats: true)
            
            RunLoop.current.add(timer!, forMode: .commonModes)
        }
        
        timer?.fire()
        
    }
    
    @objc func timerIntervalHandler(_ timer: Timer) {
        
        guard let finishTime = timer.userInfo as? Int else {
            stopTimer()
            return
        }
        
        let currentTime = Int(Date().timeIntervalSince1970)
        let remainigTime: Double = Double(finishTime - currentTime)
        
        guard remainigTime > -1 else {
            stopTimer()
            return
        }
        
        guard let timeString = formatter.string(from: remainigTime) else {
            return
        }
        printDebug("Time Remaining => \(timeString)")
        self.remainingTime.value = timeString
        self.isEnabledSendCode.value = false
        
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        self.isEnabledSendCode.value = true
    }
}

extension SendUserOtpViewModel {
    
    func transform(input: Input) -> Output {
        return false
    }
}
