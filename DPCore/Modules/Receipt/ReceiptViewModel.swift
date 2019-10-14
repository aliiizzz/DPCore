//
//  ReceiptViewModel.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/11/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

final class ReceiptViewModel: ViewModel {
    
    typealias Service = TACService
    typealias Input = ReceiptInput
    typealias Output = ReceiptOutput

    private(set) var input: Input
    private(set) weak var bindController: ReceiptViewController?

    private var fileService: GetFileService!
    
    typealias DataModelView = (title: String, value: String)
    private(set) var timer = Timer()
    private(set) var rowsData: [DataModelView] = []
    private(set) var actionButton: BorderedButton?
    private(set) var timeDown: Int = 15
    
    deinit {
        self.bindController = nil
        actionButton = nil
        timer.invalidate()
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    /// ReceiptViewModel Constructors
    ///
    /// - Parameters:
    ///   - input: `ReceiptInput` object which need to fill Receipt
    ///   - bindViewController: a viewController of `ReceiptViewController` needed to present input data
    init(input: Input, bindViewController: ReceiptViewController) {
        
        self.input = input
        self.bindController = bindViewController
        fillDatasIfNeeded()
    }
    
    /// <#Description#>
    private func fillDatasIfNeeded() {
        
        guard let viewController = self.bindController else { return }
        
        configHeaderView(bindingViewController: viewController)
        configDataView(data: self.input, bindingDataView: viewController.dataView)
        configFooterView(bindingViewController: viewController)
        viewController.dataView.tableView.reloadData()
       
    }
    
    /// <#Description#>
    ///
    /// - Parameter bindingViewController: <#bindingViewController description#>
    func configHeaderView(bindingViewController: ReceiptViewController) {
        let title: String
        let backgroundColor: UIColor
        
        switch self.input.data {
        case .pay(let response):
            if let response = response.payModel {
                title = response.status
                backgroundColor = UIColor(hex: UInt(response.color))
            }
            else {
                title = ""
                backgroundColor = SDKColors.failure
            }
        case .generic:
            title = "نا مشخص"
            backgroundColor = SDKColors.failure
        }
        
        bindingViewController.headerView.config(title: title)
        bindingViewController.headerView.backgroundColor = backgroundColor
        bindingViewController.headerView.topColor = backgroundColor
        bindingViewController.headerView.bottomColor = backgroundColor
        
    }
    
    /// <#Description#>
    ///
    /// - Parameter bindingViewController: <#bindingViewController description#>
    func configFooterView(bindingViewController: ReceiptViewController) {
    
        let buttonTitle: String
        var footerMoreText: String
        self.actionButton = bindingViewController.actionButton
        
        if self.input.status == .success {
            
            UIView.performWithoutAnimation {
                bindingViewController.actionButton.setTitle("تکمیل فرآیند خرید (00:\(self.timeDown))".persian, for: .normal)
            }
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(receiptTimerHandler(timer:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .commonModes)
        }
        else {
            
            buttonTitle = "بازگشت"
            //TODO: Localized Button Title
            bindingViewController.actionButton.setTitle(buttonTitle, for: [.normal])
            
        }
      
        bindingViewController.actionButton.defaultColor = SDKColors.primary
        bindingViewController.actionButton.isHidden = false
        let failureMessage = "در صورت کسر شدن مبلغ، وجه مورد نظر حداکثر تا ۷۲ ساعت به حساب شما بازگشت داده خواهد شد"
        
        switch (self.input.status, self.input.data) {
        case (.success, .pay(let response)):
            footerMoreText = response.payModel?.message ?? ""
        case (.failure, .pay(let response)):
            //FIXME: replace localized string for failure condition
            footerMoreText = response.payModel?.message ?? failureMessage
        default:
            footerMoreText = ""
            
        }
        
        //TODO: Localized Text
        var footerHTMLText = footerMoreText.replacingOccurrences(of: "<div>", with: "<div style=\"font-family: IRANYekan;\">")
        guard let mutableAttributeText = footerHTMLText.convertHtml()?.mutableCopy() as? NSMutableAttributedString else {
            return
        }
        
        let stringRange = NSRange(location: 0, length: mutableAttributeText.string.count)
        let mutableParaghraphStyle = NSMutableParagraphStyle()
        
        let successTextAlignment: NSTextAlignment
        
        switch bindingViewController.moreDescriptionLabel.semanticContentAttribute {
        case .forceLeftToRight:
            successTextAlignment = .left
        case .forceRightToLeft:
            successTextAlignment = .right
        default :
            successTextAlignment = .natural
        }
        
        mutableParaghraphStyle.alignment = self.input.status == .success ? successTextAlignment : .center
        
        mutableAttributeText.addAttributes([.paragraphStyle: mutableParaghraphStyle], range: stringRange)
//        mutableAttributeText.addAttributes([.font: bindingViewController.moreDescriptionLabel.font], range: stringRange)
        
        bindingViewController.moreDescriptionLabel.attributedText = mutableAttributeText
        bindingViewController.moreDescriptionLabel.isHidden = false
        
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - bindingDataView: <#bindingDataView description#>
    func configDataView(data: Input, bindingDataView: ReceiptDataView) {
      
        //TODO: convert
        switch input.data {
        case .pay(value: let response):
            if let response = response.payModel {
                
                // fetch image and fill amount and business name
                bindingDataView.config(businessName: response.title.persian, price: response.amount.persianPrice)
                bindingDataView.fetchImage(id: response.imageId)
                
                // adding data
                
                response.activityInfo.sorted { (obj1, obj2) -> Bool in
                    return obj1.key.localizedCaseInsensitiveCompare(obj2.key) == .orderedAscending
                    }.forEach {[weak self] (_, values) in
                        
                        values.forEach { (title, value) in
                            self?.addData(title: title.persian, value: (value ?? "").persian)
                        }
                }
                
            }
            
        case .generic(value: _):
            
            break
        }
        
    }
    
    @objc
    func receiptTimerHandler(timer: Timer) {
        
        guard let bindingViewController = bindController else {
            timer.invalidate()
            return
        }
        
        DispatchQueue.main.async { [weak self, weak bindingViewController] in
            
            guard let `self` = self else { return }
            
            UIView.performWithoutAnimation {
                bindingViewController?.actionButton.setTitle("تکمیل فرآیند خرید (00:0\(self.timeDown))".persian, for: .normal)
                bindingViewController?.actionButton.setNeedsLayout()
                bindingViewController?.actionButton.layoutIfNeeded()
            }
            
            if self.timeDown == 0 {
                
                if case .pay(let value) = self.input.data, let payInfo = value.payInfo {
                    
                    bindingViewController?.dismissHandler?(GlobalResponse(status: (self.input.status),
                                                                         data: ["payInfo": payInfo],
                                                                         error: self.input.error))
                    
                }
                
                timer.invalidate()
                return
            }
            
            self.timeDown -= 1
        }
        
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - value: <#value description#>
    func addData(title: String, value: String) {
        self.rowsData.append((title: title, value: value))
    }
    
    func dataFromInput() -> [String: Any] {
        return [:]
        /*TODO: handle response to Host Application
        switch self.input.data {
        case .pay(value: let response):
            return [DPCore.DPCoreSDKTrackingCodeKey: response.trackingCode,
                    DPCore.DPCoreSDKDateKey: response.date,
                    DPCore.DPCoreSDKPaymentResultKey: response.paymentResult ?? 1,
                    DPCore.DPCoreSDKRNNKey: response.rrn ?? ""]
            
        case .topUp(value: let response):
            
            return [DPCore.DPCoreSDKTrackingCodeKey: response.topUpInfo.trackingCode,
                    DPCore.DPCoreSDKDateKey: response.topUpInfo.creationDate,
                    DPCore.DPCoreSDKPaymentResultKey: response.paymentResult ,
                    DPCore.DPCoreSDKRNNKey: response.rrn ?? ""]
            
        default:
            return [:]
        }*/
    }
    
}
