//
//  PaymentViewModel.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-11-12.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

// MARK: - typealias
extension PaymentViewModel {
    
    typealias Input = PaymentInput
    typealias Output = PaymentOutput
    typealias Service = PaymentService
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

class PaymentViewModel: ViewModel {
    
    let wallet: Observable<Int?>
    
    var walletAmount: String? {
        return wallet.value?.persianPrice
    }
    
    let isLoading: Observable<Bool> = Observable(false)
    let isPurchasing: Observable<Bool> = Observable(false)
    let isInteractionEnabled: Observable<Bool> = Observable(true)
    
    let shouldPresentWalletConfirm = Observable(true)
    
    private(set) var isEnoughWalletAmount = true
    private(set) var isShowWallet = true
    private(set) var isShowCards = true
    private(set) var hasIPG = true
    
    let amount: Observable<NSMutableAttributedString>
    
    let images: Observable<[String]>
    let ipgImages: Observable<[String]>
    
    var cards: Observable<[Card]> {
        return cardsViewModel.cards
    }
    
    var banks: Observable<[BankModel]?> {
        return banksViewModel.items
    }
    
    let metaData: TacMetaData
    let ticket: String
    
    let cardsViewModel: PaymentBankCardListViewModel
    let banksViewModel: PaymentBankListViewModel
    
    weak var coordinator: PaymentCoordinator?
    
    // MARK: - Private Variables
    private var paymentService: Service?
    private var ticketInfoService: TicketInfoService?
    private var certName: String?
    
    private let lock = NSRecursiveLock()
    
    deinit {
        
        coordinator = nil
    }
    
    init(data: TacMetaData, ticket: String,
         coordinator: PaymentCoordinator? = nil,
         bankCardListViewModel: PaymentBankCardListViewModel,
         bankListViewModel: PaymentBankListViewModel) {
        
        self.metaData = data
        self.ticket = ticket
        self.wallet = Observable(nil)
        
        isShowCards = metaData.gateways?.contains(.dpg) == true
        isShowWallet = metaData.gateways?.contains(.wallet) == true
        hasIPG = metaData.gateways?.contains(.ipg) == true
        
        if let sdkInfoFeature = metaData.features.first(where: { $0.key == ProtectedFeatureKey.SDKInfo })?.value,
            let url = sdkInfoFeature.url {
            self.ticketInfoService = TicketInfoService(ticket: ticket, ticketInfoURL: url)
        }
        else if let url = metaData.infoURL {
            self.ticketInfoService = TicketInfoService(ticket: ticket, ticketInfoURL: url)
        }
        
        self.ipgImages = Observable([])
        self.images = Observable([])
        self.amount = Observable(NSMutableAttributedString(string: "ریال"))
        
        cardsViewModel = bankCardListViewModel
        banksViewModel = bankListViewModel
        
        if let walletInfo = metaData.features.first(where: { $0.key == ProtectedFeatureKey.paymentWallet })?.value {
            shouldPresentWalletConfirm.value = walletInfo.isProtected == .none
        }
    }
    
    func callTicketInfo() {
       
        if isShowCards {
            banksViewModel.fetchBankList()
            cardsViewModel.fetchCardList()
        }
        
        self.callPaymentTicketInfo()
    }
    
    func cancelledByUser() {
        
        let result = GlobalResponse.init(status: .failure,
                                         data: [:],
                                         error: SDKError(message: "درخواست توسط کاربر لغو شد",
                                                         code: SDKErrorCode.cancelledByUser.rawValue))
        
        coordinator?.navigate(to: .finish(result: false,
                                          data:nil,
                                          response: result))
    }
    
    func matchBanks(prefix: String, banks: [BankModel] = []) -> BankModel? {
        
        let banks = banks.isEmpty ? banksViewModel.items.value ?? [] : banks
        for item in banks {
            if item.cardPrefixes.contains(prefix) {
                return item
            }
        }
        return nil
    }
}

// MARK: - Pay Ticket Info Methods
extension PaymentViewModel {
    
    private func callPaymentTicketInfo() {
        
        guard let ticketInfoService = self.ticketInfoService else {
            return
        }
        
        self.isLoading.value = true
        self.isInteractionEnabled.value = false
        
        ticketInfoService.run()
            .subscribeOn(queue: .main)
            .subscribe(onNext: {[weak self] data in
                self?.onPaymentTicketSuccess(data)
            }, onError: {[weak self] error in
                self?.onTicketError(error)
            }, onErrorWithData: { [weak self] (error, data) in
                
                if let data = data as? TicketInfoResponse {
                    self?.onTicketError(error, data: data)
                }
                else {
                    self?.onTicketError(error)
                }
            })
    }
    
    private func onPaymentTicketSuccess(_ data: TicketInfoResponse) {
        
        self.isLoading.value = false
        self.isInteractionEnabled.value = true
        
        if let wallet = data.walletBalance {
            self.isEnoughWalletAmount = data.amount <= wallet
        }
        else {
            self.isEnoughWalletAmount = false
        }
        
        self.certName = data.certFile
        
        let attributedString = NSMutableAttributedString(string: "\(data.amount.persianPrice) ریال", attributes: [
            .font: UIFont(name: "IRANYekan", size: 16.0)!,
            .foregroundColor: UIColor.white
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "IRANYekan", size: 12.0)!, range: (attributedString.string as NSString).range(of: "ریال"))
        
        self.amount.value = attributedString
        self.images.value = data.images
        self.ipgImages.value = data.ipgImages ?? []
        self.wallet.value = data.walletBalance
        
    }
    
    private func onTicketError(_ error: Error, data: TicketInfoResponse? = nil) {
       
        self.isLoading.value = false
        self.isInteractionEnabled.value = true
        
        guard let data = data else {
            
            if let error = error as? NetworkResponse {
                dismiss(GlobalResponse(status: .failure, data: [:], error: error))
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
            dismiss(GlobalResponse(status: .failure, data: [:], error: error))
        }
    }
    
}

// MARK: - Payment Methods
extension PaymentViewModel {
    
    private func callPayments(pay: PayModel) {
        
        DispatchQueue.main.async {
            self.isPurchasing.value = true
            self.isInteractionEnabled.value = false
            
            self.callPayment(pay: pay)
        }
        
    }
    
    private func callPayment(pay: PayModel) {
        
        self.payService(for: pay) {[weak self] (service) in
            self?.call(service: service, pay: pay)
        }
        
    }
    
    private func call(service: Service?, pay: PayModel) {
        
        guard let service = service else {
            self.isPurchasing.value = false
            self.isInteractionEnabled.value = true
            return
        }
        
        service.set(payInfo: pay)
        service
            .run()
            .subscribeOn(queue: .main)
            .subscribe(onNext: {[weak self] data in
                self?.onPaymentSuccess(data)
                }, onError: {[weak self] error in
                    self?.onPaymentError(error)
                }, onErrorWithData: { [weak self] error, data in
                    
                    if let data = data as? PayResponse {
                        self?.onPaymentError(error, data)
                    }
                    else {
                        self?.onPaymentError(error, nil)
                    }
            })
    }
    
    private func onPaymentSuccess(_ data: PayResponse) {
        
        self.isPurchasing.value = false
        self.isInteractionEnabled.value = true
        
        let inp: ReceiptInput
        
        if let paymentResult = data.payModel?.paymentResult {
            
            if paymentResult == 0 {
                inp = ReceiptInput(status: .success, data: .pay(value: data), error: nil)
            }
            else {
                inp = ReceiptInput(status: .failure,
                                   data: .pay(value: data),
                                   error: SDKError(message: data.result.message, code: paymentResult))
            }
            
            printDebug(data)
            printDebug(inp)
            
            receipt(inp)
            
        }
    }
    
    private func onPaymentError(_ error: Error, _ data: PayResponse? = nil) {
        
        self.isPurchasing.value = false
        self.isInteractionEnabled.value = true
        
        guard let data = data else {
            
            if let error = error as? NetworkResponse {
                
                self.dismiss(GlobalResponse(status: .failure, data: [:], error: error))
                
            }
            else {
                
                var title = error.localizedDescription
                
                if let error = error as? URLError {
                    title = error.persianLocalizationError
                }
                
                let snack = SnackBar(title: title, actionTitle: nil, action: nil, timeInterval: 3)
                snack.show(delay: 0.3)
            }
            return
        }
        
        guard let level = data.result.level else { return }
        
        if level == .WARN || level == .INFO {
            let snack = SnackBar(title: data.result.message, actionTitle: nil, action: nil, timeInterval: 3)
            snack.show()
        }
        else {
            if data.payModel != nil {
                let receipt = ReceiptInput(status: .failure, data: .pay(value: data), error: error)
                self.receipt(receipt)
            }
            else {
                dismiss(GlobalResponse(status: .failure, data: [:], error: error))
            }
        }
        
    }
    
    func callWalletPayment() {
        walletPay()
    }
    
    func callPayment(pin: String, cvv2: String, source: Source, hasCardNo: Bool, cardNo: String? = nil) {
        
        if  hasCardNo {
            cardNo!.encrypt(self.certName!) {[weak self] (data, error) in
                
                guard error == nil else {
                    self?.onPaymentError(error!, nil)
                    return
                }
                
                let src = Source(value: data, type: 1, expireDate: source.expireDate, prefix: source.prefix, postfix: source.postfix)
                self?.cardVal(pin: pin, cvv2: cvv2, source: src)
            }
            
        }
        else {
            self.cardVal(pin: pin, cvv2: cvv2, source: source)
        }
    }
    
    private func cardVal(pin: String, cvv2: String, source: Source) {
        
        "{\"pin\":\"\(pin)\",\"cvv2\":\"\(cvv2)\"}".encrypt(self.certName!) {[weak self] (data, error) in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                self?.onPaymentError(error!, nil)
                return
            }
            
            let pay = PayModel(requestUUID: UUID().uuidString, ticket: GlobalInput.ticket,
                               source: source,
                               encryptedPinDto: data, certFile: strongSelf.certName!, type: .card)
            
            strongSelf.callPayments(pay: pay)
        }
        
    }
    
    private func walletPay() {
        
        guard isEnoughWalletAmount else { return }
        
        let pay = PayModel(requestUUID: UUID().uuidString,
                           ticket: GlobalInput.ticket,
                           source: nil,
                           encryptedPinDto: nil, certFile: nil, type: .wallet)
        
        self.callPayments(pay: pay)
        
    }
    
    func ipgPay(serivce: Service? = nil) {
    
        let pay = PayModel(ticket: ticket, type: .ipg)
        
        if serivce == nil {
            self.payService(for: pay) {[weak self] (newService) in
                self?.ipgPay(serivce: newService)
            }
        }
        
        guard let service = serivce else {
            return
        }
        
        guard let coordinator = coordinator else {
            return
        }
        
        let response = GlobalResponse(status: .failure,
                                      data: [:],
                                      error: SDKError(message: "redirect to IPG", code: SDKErrorCode.redirectToIPG.rawValue))

        self.dismiss(response)
        
        printDebug("navigate to ipg with url ", service.payURL)
        
        let payURL = service.payURL
        let browser = payURL.appendingPathComponent(ticket)
        coordinator.navigate(to: .ipg(url: browser))
        
    }
}

// MARK: - Feature Protections Methods
fileprivate extension PaymentViewModel {
    
    private func featureSearchKey(for pay: PayModel) -> ProtectedFeatureKey {
        
        switch pay.type {
        case .card:
            return .paymentDPG
        case .wallet:
            return .paymentWallet
        case .ipg:
            return .paymentIPG
        }
        
    }
    
    func payService(for pay: PayModel, completion : @escaping (Service?) -> Void) {
        
        let searchKey = self.featureSearchKey(for: pay)

        guard let feature = self.metaData.features.first(where: { $0.key == searchKey })?.value else {
            completion(nil)
           return
        }
        
        guard feature.isProtected == .none else {
            
            self.navigateToProtection(feature: feature,
                                      featureKey: searchKey) {[weak self] (result) in
                                        
                                        guard result else {
                                            completion(nil)
                                            return
                                        }
                                        
                                        completion(self?.service(for: feature))
            }
                                      
            return
        }
        
        completion(service(for: feature))
        
    }
  
    private func service(for feature: FeatureModel) -> Service? {
        
        guard let url = feature.url else {
            return nil
        }
        
        return Service(ticket: ticket, payURL: url)
    }
    
    private func navigateToProtection(feature: FeatureModel,
                                      featureKey: ProtectedFeatureKey,
                                      completion:@escaping (Bool) -> Void) {
        
        switch feature.isProtected {
        case .inAppVerification, .otp:
            
            guard let userDetail = metaData.userDetail,
            let tacURL = URL(string: GlobalInput.tacUrl) else { return }
            
            let confirm = UserConfirmViewModelInput(ticket: ticket,
                                                    tacURL: tacURL,
                                                    userDetail: userDetail,
                                                    features: [featureKey],
                                                    isRequired: false) { (result) in
                                                        completion(result)
            }
            
            coordinator?.navigate(to: .userVerification(data:confirm))
            
        case .pin:
            
            guard let userDetail = metaData.userDetail else { return }
            
            let protection = PinProtectionInput(ticket: ticket,
                                                userId: userDetail.userId,
                                                feature: featureKey,
                                                isRequired: false) { result in
                                                    completion(result == .success)
            }
            
            coordinator?.navigate(to: .pin(data: protection))
        case .none:
            break
        }
        
    }
    
}

// MARK: - Coordinator Helper Methods
fileprivate extension PaymentViewModel {
    
    func dismiss(_ response: SDKResponse) {
        coordinator?.navigate(to: .finish(result: false,
                                          data: nil,
                                          response: response))
    }
    
    func receipt(_ data: ReceiptInput) {
        coordinator?.navigate(to: .finish(result: true,
                                          data: data,
                                          response: nil))
    }
    
}
