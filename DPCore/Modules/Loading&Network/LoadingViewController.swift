//
//  LoadingViewController.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-28.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

final class LoadingViewController: DPBaseViewController {
    
    var viewModel: LoadingViewModel?
    
    var disposeBags = Disposal()
    
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.image = UIImage(named: "logoSdk", in: Bundle(for: type(of: self)), compatibleWith: nil)
        }
    }
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var cancel: BorderedButton!
    @IBOutlet weak var retry: BorderedButton!
    
    private var indicator: UIActivityIndicatorView!
    
    deinit {
        
        disposeBags.removeAll()
        viewModel = nil
        indicator?.removeFromSuperview()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVm()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        
        self.indicator = UIActivityIndicatorView()
        
        self.message.text = "اشکال در اتصال به اینترنت"
        self.retry.setTitle("تلاش مجدد", for: .normal)
        self.cancel.setTitle("انصراف", for: .normal)
        indicator.color = SDKColors.DarkGray
        indicator.frame.size = CGSize(width: 40, height: 40)
        indicator.center = CGPoint(x: self.view.center.x, y: self.view.center.y+60)
        self.view.addSubview(indicator)
        hideButtons()
        showIndicator()
    }
    
    func initVm() {
        
        guard let vm = self.viewModel else { return }
        
        vm.isLoading
            .observer(on: DispatchQueue.main)
            .observe {[weak self] (isLoading, _) in
                switch isLoading {
                case true:
                    self?.showIndicator()
                    self?.hideButtons()
                case false:
                    self?.hideIndicator()
                    self?.showButtons()
                }
            }
            .add(to: &disposeBags)
        
        vm.isPending
            .observer(on: .main)
            .observe {[weak self] (isPending, _) in
                
                self?.retry.isHidden = isPending
                self?.cancel.isHidden = isPending
                
                if isPending {
                    self?.hideTitle()
                }
                else {
                    self?.showTitle()
                }
        }.add(to: &disposeBags)
        
        vm.fetchDataFromServer {[weak self] (result, error) in
           self?.handleFetchResponse(result: result, error: error)
        }
    }
    
    private func hideButtons() {
        self.retry.isHidden = true
        self.cancel.isHidden = true
        self.hideTitle()
    }
    
    private func showButtons() {
        self.retry.isHidden = false
        self.cancel.isHidden = false
        self.showTitle()
    }
    
    private func showIndicator() {
        self.indicator.startAnimating()
    }
    
    private func hideIndicator() {
        self.indicator.stopAnimating()
    }
    
    private func hideTitle() {
        self.message.isHidden = true
    }
    
    private func showTitle() {
        self.message.isHidden = false
    }
    
    @IBAction func retryAction(_ sender: Any) {
        
        showIndicator()
        hideButtons()
        
        self.viewModel?.fetchDataFromServer {[weak self] (result, error) in
            self?.handleFetchResponse(result: result, error: error)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        viewModel?.cancelledByUser()
        
    }
    
    private func handleFetchResponse(result: Bool, error: Error?) {
        
        guard error == nil, result else {
            self.showButtons()
            return
        }
        
        self.hideIndicator()
        self.hideButtons()
        
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
