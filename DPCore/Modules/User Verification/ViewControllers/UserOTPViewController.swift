//
//  UserOTPViewController.swift
//  DPCore
//
//  Created by Amir Roudsari on 7/2/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

class UserOTPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var digiInputView: DigitInputView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var submitBtn: BorderedButton!
    @IBOutlet weak var retryButton: BorderedButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!

    private lazy var buttonList = [submitBtn]
    private static var timerVal: Int = 0
    
    var sendOtpViewModel: SendUserOtpViewModel!
    var validateOTPViewModel: ValidateOTPViewModel!
    
    let keyboardObserver = KeyboardObserver()
    
    private var disposeBag = Disposal()
    
    deinit {
        sendOtpViewModel = nil
        validateOTPViewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        bindViewModels()
        sendCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = digiInputView.textField?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        digiInputView.canDismisskeyboard = true
        view.endEditing(true)
    }
    
    func onSendOTPSuccess() {
        digiInputView.isUserInteractionEnabled = true
        _ = digiInputView.becomeFirstResponder()
    }
    
    func onError() {
        digiInputView.digiInputType = .disabled
        digiInputView.isUserInteractionEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buttonInit() {
        retryButton.setTitle("ارسال کد جدید", for: .normal)
        retryButton.isEnabled = false
    }
    
    func initViews() {
        
        digiInputView.canDismisskeyboard = false
        
        buttonInit()
        
        keyboardObserver.observe {[weak self] (event) in
            guard let `self` = self else { return }
            
            switch event.type {
            case .willHide, .willChangeFrame, .willShow :
                
                var distance = event.type == .willHide ? 8 : event.keyboardFrameEnd.height
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    distance = event.type == .willHide ? 8 : event.keyboardFrameEnd.height - (UIScreen.main.bounds.height - self.view.bounds.height)
                }
                
                UIView.animate(withDuration: event.duration,
                               delay: 0.0,
                               options: [.allowUserInteraction, .beginFromCurrentState, event.options],
                               animations: {
                                self.scrollViewBottomConstraint.constant = distance
                                self.view.layoutIfNeeded()
                                
                }, completion: {[weak self] _ in
                    
                })
                
            default:
                break
            }
            
        }

    }
    
    func onValidationSuccess() {
        self.digiInputView.canDismisskeyboard = true
        _ = self.digiInputView.textField?.resignFirstResponder()
        self.digiInputView.digiInputType = .normal

    }
    
    func onValidationError() {
        self.digiInputView.digiInputType = .error
//        self.hintLabel.text = "کد وارد شده صحیح نیست."
        self.digiInputView.isUserInteractionEnabled = true
    }
    
    @IBAction func resendCode(_ sender: UIButton) {
        sendCode()
    }
    
    @IBAction func sendData(_ sender: Any) {
       if let code = digiInputView.textField?.text?.english {
            validateOtp(code: code)
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        guard validateOTPViewModel.isMandetory == true else {
            validateOTPViewModel.cancelledByUser()
            return
        }
        
        self.presentCancelView {[weak self] (result) in
            guard result else { return }
            self?.validateOTPViewModel.cancelledByUser()
        }
    }
    
    func updateSubmitLoadingUI(_ isLoading: Bool) {
        
        guard !(isBeingDismissed || self.isMovingFromParentViewController) else { return }
        
        self.submitBtn.loadingIndicator(isLoading, 1015)
        self.digiInputView.isUserInteractionEnabled = !isLoading
        self.digiInputView.canDismisskeyboard = isLoading
        if isLoading {
            self.digiInputView.textField?.resignFirstResponder()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {[weak self] in
                self?.digiInputView.textField?.becomeFirstResponder()
            }
            
        }
    }
    
    func updateRetryLoadingUI(_ isLoading: Bool) {
        self.retryButton.loadingIndicator(isLoading, 1015)
        self.retryButton.setTitle("", for: .disabled)
        self.digiInputView.isUserInteractionEnabled = !isLoading
    }
    
    func presentCancelView(completion :@escaping (_ isCancelled: Bool) -> Void) {
        
        let resultBlock = {[weak self] result in
            
            self?.presentedViewController?.dismiss(animated: true,
                                                   completion: {
                                                    completion(result)
            })
            
        }
        
        let cancelView = CancelModalView(continue_action: {
            resultBlock(false)
        }, decline: {
            resultBlock(true)
        })
        
        cancelView.color = SDKColors.Decline
        cancelView.setView(nextStr: "ادامه پرداخت", cancelStr: "انصراف از پرداخت",
                           icons: UIImage(named: "warning", in: Bundle(for: type(of: self)), compatibleWith: nil) ?? UIImage())
        let cancelModal: ConfirmModalView
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            cancelModal = ConfirmModalView(title: "انصراف از پرداخت ", view: cancelView, frame: self.view.bounds)
        }
        else {
            cancelModal = ConfirmModalView(title: "انصراف از پرداخت ", view: cancelView, frame: CGRect(origin: .zero, size: CGSize(width: 120, height: 120)))
        }
        
        let modalDialog = ModalDialogViewController(contentView: cancelModal)
        
        self.present(modalDialog, animated: true) {
            
        }
    }
    
}

// MARK: - Logic And ViewModels Methods
extension UserOTPViewController {
    
    func bindViewModels() {
        bindOTPViewModel()
        bindOTPVerficationViewModel()
    }
    
    func bindOTPViewModel() {
        
        sendOtpViewModel.mobileNumber
            .observer(on: .main)
            .observe {[weak self] (value, _) in
                self?.phoneLabel.text = value
        }.add(to: &disposeBag)
        
        sendOtpViewModel.isLoading
            .observer(on: .main)
            .observe {[weak self] (isLoading, _) in
                self?.updateRetryLoadingUI(isLoading)
        }.add(to: &disposeBag)
        
        sendOtpViewModel.isEnabledSendCode
            .observer(on: .main)
            .observe {[weak self] (isEnabled, _) in
                self?.retryButton.isEnabled = isEnabled
        }.add(to: &disposeBag)
        
        sendOtpViewModel.remainingTime
            .skipFirst()
            .observer(on: .main)
            .observe {[weak self] (time, _) in
                UIView.performWithoutAnimation {
                    self?.retryButton.setTitle(time, for: .disabled)
                }
        }.add(to: &disposeBag)
        
    }
    
    func bindOTPVerficationViewModel() {
        
        if !validateOTPViewModel.isMandetory {
            
            var image = UIImage(named: "backbtn",
                                in: Bundle(for: type(of: self)),
                                compatibleWith: nil)
            image = image?.imageFlippedForRightToLeftLayoutDirection()
            
            self.closeButton.setImage(image, for: .normal)
            self.closeButton.setImage(image, for: .highlighted)
            
        }
        
        validateOTPViewModel.isLoading
            .observer(on: .main)
            .observe {[weak self] (isLoading, _) in
                self?.updateSubmitLoadingUI(isLoading)
        }.add(to: &disposeBag)
        
        validateOTPViewModel.isVerifyCode
            .observer(on: .main)
            .observe {[weak self] (isVerifiy, _) in
                guard let result = isVerifiy else {
                    self?.digiInputView.digiInputType = .normal
                    self?.hintLabel.text = nil
                    return
                }
                self?.handle(result: result)
        }.add(to: &disposeBag)
        
        validateOTPViewModel.isEnableButton
            .observer(on: .main)
            .observe {[weak self] (isEnabled, _) in
                self?.submitBtn.isEnabled = isEnabled
            }.add(to: &disposeBag)
        
        validateOTPViewModel.bind(digiInput: digiInputView)
        
    }
    
    func validateOtp(code: String) {
        
        validateOTPViewModel
            .verifyCode(code: code) {[weak self] (result, _) in
           self?.handle(result: result)
        }
    }
    
    func sendCode() {
        
        sendOtpViewModel
            .sendUserOTP { (result, _) in
            
            guard result else {
                self.onError()
                return
            }
            
            self.onSendOTPSuccess()
        }
    }
    
    func handle(result: Bool) {
        
        guard result else {
            self.onValidationError()
            return
        }
        
        self.onValidationSuccess()
    }
    
}
