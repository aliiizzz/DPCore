//
//  TACViewController.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-27.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit
import WebKit

class TACViewController: DPBaseViewController {
    
    private let webView: WKWebView = WKWebView()
    
    @IBOutlet weak var nextBtn: BorderedButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    var viewModel: AcceptTACViewModel?
    
    var disposeBag = Disposal()
    
    deinit {
        disposeBag.removeAll()
        viewModel = nil
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.clipsToBounds = false
        backView.addSubview(webView)
        constSetter(webView, to: backView)
        initView()
        initVm()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func initView() {
        self.title = "قوانین و مقررات"
        self.nextBtn.setTitle("قبول شرایط و ادامه", for: .normal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close", in: Bundle(for: type(of: self)), compatibleWith: nil),
                                                                 landscapeImagePhone: UIImage(named: "close", in: Bundle(for: type(of: self)), compatibleWith: nil),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(cancelTAC(_:)))
        
    }
    
    private func initVm() {
        guard let vm = self.viewModel else { return }
        
        webView.load(URLRequest(url: vm.tacURL))
        
        vm.isLoading
            .observer(on: DispatchQueue.main)
            .observe { [weak self] newValue, _  in
                self?.nextBtn.loadingIndicator(newValue)
            }
            .add(to: &disposeBag)
        
        vm.shouldAcceptTAC
            .observer(on: DispatchQueue.main)
            .observe { [weak self] newValue, _  in
                self?.nextBtn.isHidden = !newValue
                self?.gradientView.isHidden = !newValue
            }
            .add(to: &disposeBag)
        
    }
    
    @objc func cancelTAC(_ sender: Any) {
        
        guard let vm = self.viewModel, vm.shouldAcceptTAC.value else {
            viewModel?.dismissMe()
            return
        }
        
        vm.cancelledByUser()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        guard let vm = self.viewModel, vm.shouldAcceptTAC.value else {
            viewModel?.dismissMe()
            return
        }
        
        self.viewModel?.runService()
    }
    
}
