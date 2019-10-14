//
//  CustomModalView.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-08-03.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

//
//  SnackBarView.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-08-02.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class CustomModalView: UIView, Modal {
    var timeInterval: Double?
    var backgroundShadow: UIColor = UIColor.clear
    var backgroundView: UIView = UIView()
    var dialogView: UIView = UIView()
   
    @IBInspectable
    open var background: UIColor = .black {
        didSet {
            backgroundColor = background
        }
    }
    
    convenience init(view: UIView) {
        self.init(frame: UIScreen.main.bounds)
    }
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(view: UIView, timeInterval: Double?) {
        dialogView.clipsToBounds = true
        self.timeInterval = timeInterval
        backgroundView.frame = frame
        backgroundView.backgroundColor = self.backgroundShadow
        backgroundView.alpha = 0.0
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-32
        let dialogViewHeight = CGFloat(48)
        dialogView.frame.origin = CGPoint(x: 32, y: dialogViewHeight)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        
        addSubview(dialogView)
        
        dialogView.addSubview(view)
        constSetter(view)
    }
    // MARK: - it's duplicate please remove that
    func constSetter(_ view: UIView, const: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        dialogView.topAnchor.constraint(equalTo: view.topAnchor, constant: const).isActive = true
        dialogView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const).isActive = true
        dialogView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: const).isActive = true
        dialogView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: const).isActive = true
    }
    
    @objc func didTappedOnBackgroundView() {
        dismiss(animated: true)
    }
    
}
