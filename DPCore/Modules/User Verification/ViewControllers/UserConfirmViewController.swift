//
//  UserConfirmViewController.swift
//  DPCore
//
//  Created by Amir Roudsari on 7/2/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

class UserConfirmViewController: DPBaseViewController {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewModel: UserConfirmViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneLabel.text = viewModel.mobile
        
        if !viewModel.isMandetory {
            
            var image = UIImage(named: "backbtn",
                                in: Bundle(for: type(of: self)),
                                compatibleWith: nil)
          
            image = image?.imageFlippedForRightToLeftLayoutDirection()
            
            self.closeButton.setImage(image, for: .normal)
            self.closeButton.setImage(image, for: .highlighted)
            
        }
    }
    
    @IBAction func acceptBtn(_ sender: Any) {
        viewModel.didAccpetTAC()
    }
    
    @IBAction func tacBtn(_ sender: Any) {
        viewModel.didTapOnTerms()
    }
    
    @IBAction func close(_ sender: Any) {
        
        guard viewModel?.isMandetory == true else {
            viewModel?.didCancelByUser()
            return
        }
        
        self.presentCancelView {[weak self] (result) in
            guard result else { return }
            self?.viewModel?.didCancelByUser()
        }
        
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
