//
//  TACView.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-08-03.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit
import WebKit
class ConfirmModalView: UIView, Modal {
    
    var backgroundView = UIView()
    var dialogView = UIView()
    var backgroundShadow =  UIColor()
    
    var timeInterval: Double?
    
    convenience init(title: String, view: UIView) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title, view: view)
        
    }
    
    convenience init(title: String, view: UIView, frame: CGRect) {
        self.init(frame: frame)
        initialize(title: title, view: view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//         super.layoutSubviews()
//
//        backgroundView.frame = bounds
//
//        let dialogViewWidth = bounds.width - 64
//
//        for view in self.subviews where view != backgroundView && view != dialogView && view.tag != -200005 {
//            switch view {
//            case let label as UILabel:
//                label.frame.size = CGSize(width: dialogViewWidth - 16, height: 30)
//            case let seperatorView as UIView:
//                seperatorView.frame.size = CGSize(width: dialogViewWidth, height: 1)
//            }
//        }
//
//        if let view = dialogView.viewWithTag(-200005) {
//
//            view.frame.size = CGSize(width: dialogViewWidth - 16, height: dialogViewWidth - 16)
//        }
//
////        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogView.frame.height)
//
//    }
    
    func initialize(title: String, view: UIView) {
        view.endEditing(true)
        
        self.clipsToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "IRANYekan", size: 16.0)
        addSubview(titleLabel)
        titleLabel.pinToSuperviewEdge(exclude: .bottom, inset: 16.0, priority: .required)
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.groupTableViewBackground
        addSubview(separatorLineView)
        separatorLineView.pinEdge(.top, to: .bottom, of: titleLabel, inset: 16)
        separatorLineView.pinToSuperviewEdge(.leading, inset: 0, priority: .required)
        separatorLineView.pinToSuperviewEdge(.trailing, inset: 0, priority: .required)
        separatorLineView.set(.height, to: 1)
        
        addSubview(view)
        view.pinEdge(.top, to: .bottom, of: separatorLineView, inset: 16.0)
        view.pinToSuperviewEdge(exclude: .top, inset: 8.0, priority: .required)
       
        view.setContentCompressionResistance(for: .vertical, to: .required)
        self.setContentCompressionResistance(for: .vertical, to: .required)
        self.backgroundColor = UIColor.white
    }
    
    @objc func didTappedOnBackgroundView() {
        dismiss(animated: true)
    }
    
}
