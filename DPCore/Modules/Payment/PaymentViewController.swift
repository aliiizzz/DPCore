//
//  PaymentViewController.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-31.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class PaymentViewController: DPBaseViewController {
    
    @IBOutlet weak var payButton: BorderedButton!
    @IBOutlet weak var bankImages: UICollectionView!
    @IBOutlet weak var ipgBankImages: UICollectionView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var amountBackView: RoundedView!
    @IBOutlet weak var amountVal: UILabel!
    @IBOutlet weak var bankCardViews: BankCardCollectionView!
    @IBOutlet weak var paymentInputContainerView: UIView!
    @IBOutlet weak var ipgContainerView: UIView!
    
    @IBOutlet weak var cardNo: DPMaterialTextField! {
        didSet {
            cardNo.isResponseToCopyPaste = false
        }
    }
    @IBOutlet weak var passCode: DPMaterialTextField! {
        didSet {
            passCode.isResponseToCopyPaste = false
        }
    }
    @IBOutlet weak var cvv2: DPMaterialTextField! {
        didSet {
            cvv2.isResponseToCopyPaste = false
        }
    }
    @IBOutlet weak var expireDate: DPMaterialTextField! {
        didSet {
            expireDate.isResponseToCopyPaste = false
        }
    }
    
    private var network: Reachability?
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var viewModel: PaymentViewModel?
    var index: Int = 0
    
    let datePicker = MonthYearPickerView()
    let toolbar = UIToolbar()
    
    var bankList: [BankModel] = []
    
    private var cancelModal: ConfirmModalView?
    
    let keyboardObserver = KeyboardObserver()
    
    var newCell: BankCardViewCell?
    var selectedCard: Source = Source(value: "", type: 0, expireDate: "", prefix: "", postfix: "")
    
    let doneButton = UIBarButtonItem(title: "تایید",
                                     style: UIBarButtonItemStyle.done,
                                     target: self,
                                     action: #selector(getDate))
    let cancelButton = UIBarButtonItem(title: "انصراف",
                                       style: UIBarButtonItemStyle.done,
                                       target: self,
                                       action: #selector(closeDatePicker))
    
    private var disposeBags = Disposal()
    
    deinit {
        
        cancelModal = nil
        viewModel = nil
        NotificationCenter.default.removeObserver(self)
        network?.stopNotifier()
        network = nil
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        initView()
        viewModel?.callTicketInfo()
        //self.hideKeyboardWhenTappedAround()
        //self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            self.network =  Reachability()!
            try self.network?.startNotifier()
            NotificationCenter
                .default
                .addObserver(self,
                             selector: #selector(reachabilityChanged(value:)),
                             name: .reachabilityChanged,
                             object: network)
            
        }
        catch {
            
        }
    }
    
    @objc private func reachabilityChanged(value: Notification) {
        guard let reachability = value.object as? Reachability else { return }
        changeState(reachability)
    }
    
    private func changeState(_ reachability: Reachability) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.network?.stopNotifier()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.amountBackView.roundingCorners = [.topLeft, .topRight]
        self.amountBackView.cornerRadiusSize = CGSize(width: 8, height: 8)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func payAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if (network?.connection)! == .none {
            let snack = SnackBar(title: "اشکال در اتصال به اینترنت", actionTitle: nil, action: nil, timeInterval: 3)
            snack.show()
            return
        }
        
        switch index {
            
        case BankCardCollectionView.isIPGIndex :
            
            self.viewModel?.ipgPay()
            return
            
        case BankCardCollectionView.isWalletIndex :
            
            guard viewModel?.shouldPresentWalletConfirm.value == true else {
                self.viewModel?.callWalletPayment()
                return
            }
            
            self.presentWalletConfrimView {[weak self] (confrimed ) in
                guard confrimed else {
                    return
                }
                
                self?.viewModel?.callWalletPayment()
            }
            
        case BankCardCollectionView.isNewIndex:
            guard let cvv2 = self.cvv2.text?.english,
                let passCode = self.passCode.text?.english,
                let cardNumber = self.cardNo.text?.english.cardFormatted.replacingOccurrences(of: "-", with: ""),
                let expireDate = self.expireDate.text?.english else { return }
            
            let newCard = Source(value: "newCard",
                                 type: 1, //type 1 mean card is new
                expireDate: expireDate,
                prefix: String(cardNumber.prefix(6)),
                postfix: String(cardNumber.suffix(4)))
            
            self.viewModel?.callPayment(pin: passCode,
                                        cvv2: cvv2,
                                        source: newCard,
                                        hasCardNo: true,
                                        cardNo: cardNumber)
        default:
            
            if self.cvv2.text != nil && self.passCode.text != nil {
                
                guard let cvv2 = self.cvv2.text?.english,
                    let passCode = self.passCode.text?.english,
                    let _ = self.cardNo.text?.english else { return }
                
                self.viewModel?.callPayment(pin: passCode,
                                            cvv2: cvv2,
                                            source: self.selectedCard,
                                            hasCardNo: false,
                                            cardNo: nil)
            }
        }
        
    }
    
    func presentWalletConfrimView (completion: @escaping (_ confrimed: Bool) -> Void) {
        
        let walletConfrimView = WalletConfrimView.fromNib()
        
        walletConfrimView.action = {[weak self] _, confrimed in
            
            self?.presentedViewController?.dismiss(animated: true, completion: {
                completion(confrimed)
            })
            
        }
        
        let copyWalletView = WalletCardViewCell.fromNib()
        
        copyWalletView.config(amount: self.viewModel!.walletAmount, enoughAmount: self.viewModel!.isEnoughWalletAmount)
        walletConfrimView.addWallet(view: copyWalletView)
        
        //        walletConfrimView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        let modalDialog = ModalDialogViewController(contentView: walletConfrimView)
        
        self.present(modalDialog, animated: true) {
            
        }
        
    }
    
    @objc func cancel(_ sender: Any) {
        view.endEditing(true)
        let cancelView = CancelModalView(continue_action: self.hideCancelView, decline: continueCancel)
        cancelView.color = SDKColors.Decline
        cancelView.setView(nextStr: "ادامه پرداخت", cancelStr: "انصراف از پرداخت",
                           icons: UIImage(named: "warning", in: Bundle(for: type(of: self)), compatibleWith: nil) ?? UIImage())
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.cancelModal = ConfirmModalView(title: "انصراف از پرداخت ", view: cancelView, frame: self.view.bounds)
        }
        else {
            self.cancelModal = ConfirmModalView(title: "انصراف از پرداخت ", view: cancelView)
        }
        
        let modalDialog = ModalDialogViewController(contentView: cancelModal!)
        
        self.present(modalDialog, animated: true) {
            
        }
        
    }
    
    private func hideCancelView() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func continueCancel() {

        self.presentedViewController?.dismiss(animated: true, completion: {[weak self] in
             self?.viewModel?.cancelledByUser()
        })
       
    }
    
    private func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.isLoading
            .observer(on: .main)
            .observe {[weak self] (isLoading, _) in
                
                guard let `self` = self else { return }
                self.paymentInputContainerView.isHidden = isLoading
                
            }.add(to: &disposeBags)
        
        viewModel.cardsViewModel
            .isFetchingCards
            .observer(on: .main)
            .skipFirst()
            .observe {[weak self] (isFetchingCards, _) in
                
                guard let `self` = self else { return }
                UIView.animate(withDuration: 0.2, animations: {
                    self.stackView.isHidden = isFetchingCards
                    self.payButton.superview?.isHidden = isFetchingCards
                    self.view.layoutIfNeeded()
                    self.bankCardViews.reloadData()
                })
                
            }.add(to: &disposeBags)
        
        viewModel.amount
            .observer(on: .main)
            .observe {[weak self] (attributedString, _) in
                self?.amountVal.attributedText = attributedString
            }.add(to: &disposeBags)
        
        viewModel.wallet
            .observer(on: .main)
            .skipFirst()
            .observe {[weak self] (wallet, _) in
                self?.update(wallet: wallet)
            }.add(to: &disposeBags)
        
        viewModel
            .cards
            .observer(on: .main)
            .skipFirst()
            .observe {[weak self] (cards, _ ) in
                self?.updateCards(cards)
            }.add(to: &disposeBags)
        
        viewModel.isInteractionEnabled
            .observer(on: .main)
            .observe {[weak self] (isInteractionEnabled, _) in
                
                if isInteractionEnabled {
                    self?.enableInteraction()
                }
                else {
                    self?.disableInteraction()
                }
                
            }.add(to: &disposeBags)
        
        viewModel.isPurchasing
            .observer(on: .main)
            .observe {[weak self] (isPurchasing, _) in
                self?.payButton.loadingIndicator(isPurchasing, -10005)
            }.add(to: &disposeBags)
        
        viewModel
            .images
            .observer(on: .main)
            .observe {[weak self] (images, _) in
                printDebug("images => \(images)")
                self?.bankImages.reloadData()
            }.add(to: &disposeBags)
        
        viewModel.ipgImages.observer(on: .main)
            .observe {[weak self] (ipgImages, _) in
                printDebug("ipgImages => \(ipgImages)")
                self?.ipgBankImages.reloadData()
        }.add(to: &disposeBags)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
