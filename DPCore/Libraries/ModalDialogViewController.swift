//
//  ModalDialogViewController.swift
//  DPCore
//
//  Created by Farshad Mousalou on 12/8/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class ModalDialogViewController: UIViewController {

    private let transitionsController = ModalTransitionController()
    
    var cornerRadius: CGFloat = 8.0 {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
            self.view.layer.cornerRadius = cornerRadius
        }
    }
    
    private var contentView: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    convenience init(contentView: UIView) {
        self.init()
        self.commonInit()
        self.contentView = contentView
    }
    
    deinit {
        contentView.removeFromSuperview()
        contentView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(contentView)
        self.view.constSetter(contentView, to: self.view, const: 0)

        contentView.clipsToBounds = true
        contentView.setContentHuggingPriority(.required, for: .horizontal)
        contentView.setContentHuggingPriority(.required, for: .vertical)
        contentView.layoutIfNeeded()
        let contentSize = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        self.preferredContentSize = contentSize
        
        contentView.layer.cornerRadius = cornerRadius
        view.layer.cornerRadius = self.cornerRadius
        view.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4 / 2
        view.layer.shadowPath = nil
        
        self.transitionsController.duration = 0.5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

private extension ModalDialogViewController {
    
    func commonInit() {
        super.transitioningDelegate = transitionsController
        super.modalPresentationStyle = .custom
    }
    
}
