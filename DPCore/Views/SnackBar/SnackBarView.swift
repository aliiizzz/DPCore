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
class SnackBarView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    var clousre: closure = {}
    
    @IBInspectable
    open var title: String = "" {
        didSet {
            self.titleLabel?.text = title
        }
    }
    
    @IBInspectable
    open var background: UIColor = .black {
        didSet {
            backgroundColor = background
        }
    }
    
    convenience init(title: String, actionTitle: String?, clousre:(() -> Void)?) {
        self.init(frame: UIScreen.main.bounds)
        let temp = fromNib() as! SnackBarView
        temp.initialize(title: title, actionTitle: actionTitle, action: clousre)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func action(_ sender: Any) {
        clousre()
    }
    
    func initialize(title: String, actionTitle: String?, action:(() -> Void)?) {
        self.title = title
        if let closure = action {
            self.clousre = closure
        }
        if let temp = actionTitle {
            self.actionButton?.setTitle(temp, for: .normal)
        }
        else {
            self.actionButton?.removeFromSuperview()
        }
    }
    
}

struct SnackBar {
    private let customView = CustomModalView()
    private var snackBarView: SnackBarView!
    
    init(message: MessageModel, timeInterval: Double?) {
        snackBarView = SnackBarView(title: message.title, actionTitle: message.action?.title, clousre: message.action?.action)
        customView.initialize(view: snackBarView, timeInterval: timeInterval)
    }
    
    init(title: String, actionTitle: String?, action:(() -> Void)?, timeInterval: Double?) {
        // MARK: - it can be better than this it's like bullshit
        snackBarView = SnackBarView(title: title, actionTitle: actionTitle, clousre: action)
        customView.initialize(view: snackBarView, timeInterval: timeInterval)
        
    }
    
    func show(delay: TimeInterval = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.customView.show(animated: true, place: CGPoint(x: self.customView.center.x, y: self.customView.center.y * 1.9))
        }
    }
    
}
