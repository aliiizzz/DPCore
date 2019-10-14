//
//  PinProtectionViewController.swift
//  DPCore
//
//  Created by Farshad Mousalou on 6/26/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import UIKit
import AudioToolbox

class PinProtectionViewController: DPBaseViewController {

    @IBOutlet weak var imageView1: RoundedPinImageView!
    @IBOutlet weak var imageView2: RoundedPinImageView!
    @IBOutlet weak var imageView3: RoundedPinImageView!
    @IBOutlet weak var imageView4: RoundedPinImageView!
    
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var pinStackView: UIStackView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var disposeBag = Disposal()
    
    var viewModel: PinProtectionViewModel? {
        didSet {
            guard self.isViewLoaded else {
                return
            }
            
            bindViewModel()
        }
    }
    
    deinit {
        disposeBag.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPinRoundedImage(index: 0)
        textField.text = ""
        textField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - UI Methods
extension PinProtectionViewController {
    
    func initViews() {
        
        self.title = "رمز عبور"
        self.titleLabel.text = "رمز عبور خود را وارد کنید."
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        pinView.semanticContentAttribute = .forceLeftToRight
        
        if viewModel?.isMandetory == false {
          
                self.navigationItem.leftBarButtonItem?.image = UIImage(named: "backbtn",
                                                                       in: Bundle(for: type(of: self)),
                                                                       compatibleWith: nil)?.imageFlippedForRightToLeftLayoutDirection()
        }
    }
    
    func setPinRoundedImage(index: Int) {
        switch index {
        case 0:
            grayImageView(view: imageView1)
            grayImageView(view: imageView2)
            grayImageView(view: imageView3)
            grayImageView(view: imageView4)
            
        case 1:
            blueImageView(view: imageView1)
            grayImageView(view: imageView2)
            grayImageView(view: imageView3)
            grayImageView(view: imageView4)
            
        case 2:
            blueImageView(view: imageView1)
            blueImageView(view: imageView2)
            grayImageView(view: imageView3)
            grayImageView(view: imageView4)
            
        case 3:
            blueImageView(view: imageView1)
            blueImageView(view: imageView2)
            blueImageView(view: imageView3)
            grayImageView(view: imageView4)
            
        case 4:
            blueImageView(view: imageView1)
            blueImageView(view: imageView2)
            blueImageView(view: imageView3)
            blueImageView(view: imageView4)
        default:
            break
        }
    }
    
    func grayImageView(view: UIImageView) {
        view.layer.borderWidth = 2
        view.layer.borderColor = SDKColors.blackThirty.cgColor
        view.backgroundColor = UIColor.white
    }
    
    func blueImageView(view: UIImageView) {
        view.layer.borderWidth = 0
        view.backgroundColor = SDKColors.primaryLight
    }
    
    func redImageVeiw(view: UIImageView) {
        view.layer.borderWidth = 0
        view.backgroundColor = SDKColors.secondaryLight
    }
    
    func invalidPin() {
        redImageVeiw(view: imageView1)
        redImageVeiw(view: imageView2)
        redImageVeiw(view: imageView3)
        redImageVeiw(view: imageView4)
        errorAnimation()
    }
    
    func errorAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: pinStackView.center.x - 10, y: pinStackView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: pinStackView.center.x + 10, y: pinStackView.center.y))
        pinStackView.layer.add(animation, forKey: "position")
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {[weak self] in
            self?.setPinRoundedImage(index: 0)
            self?.textField.text = ""
            self?.textField.becomeFirstResponder()
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    func pinEntered() {
        self.textField.resignFirstResponder()
        self.view.isUserInteractionEnabled = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
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

// MARK: - Logic and ViewModel Methods
extension PinProtectionViewController {
    
    @IBAction func closeView(_ sender: Any) {
        
        guard viewModel?.isMandetory == true else {
            viewModel?.cancelledByUser()
            return 
        }
        
        self.presentCancelView {[weak self] (result) in
            guard result else { return }
            self?.viewModel?.cancelledByUser()
        }
    }
    
    private func triggleAction(with pinText: String) {
        
        guard !pinText.isEmpty else {
            
            self.setPinRoundedImage(index: 0)
            self.textField.text = ""
            self.textField.becomeFirstResponder()
            self.titleLabel.text = "یکبار دیگر رمز عبور جدید خود را وارد کنید."
            
            return
        }
        
        self.pinEntered()
        self.viewModel?.verify(pin: pinText) {[weak self] (result) in
            
            guard result == false  else {
                return
            }
            
            self?.invalidPin()
            
        }
    }
    
    func bindViewModel() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.isLoading.observer(on: .main)
            .observe {[weak self] (isLoading, _ ) in
                
                self?.activityIndicator.isHidden = isLoading 
                
                if isLoading {
                    self?.activityIndicator.startAnimating()
                }
                else {
                    self?.activityIndicator.stopAnimating()
                }
                
        }.add(to: &disposeBag)
        
        viewModel.isVerifyPin
            .observer(on: .main)
            .skipFirst()
            .observe {[weak self] (isValid, _) in
                
                guard isValid == false else {
                    return
                }
                self?.invalidPin()
        }
        
    }
}

extension PinProtectionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = self.textField.text?.english,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        guard count <= 4 else {
            return false
        }
        
        setPinRoundedImage(index: count)
        return true
    }
    
    @objc func textFieldDidChangeText(_ textField: UITextField) {
        
        guard let text = textField.text?.english, text.count == 4 else {
            return
        }
        
        triggleAction(with: text)
        
    }
    
}
