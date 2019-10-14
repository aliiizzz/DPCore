//
//  CancelModalView.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-09-17.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class CancelModalView: UIView {
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var leftBottomView: UIView!
    var continueAction: closure!
    var declineAction: closure!
    @IBOutlet weak var rightBottomView: UIView!
    var color: UIColor = SDKColors.primaryLight {
        didSet {
            self.layoutSubviews()
        }
    }
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var text: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    convenience init(continue_action:@escaping closure, decline:@escaping closure) {
        self.init()
        self.continueAction = continue_action
        self.declineAction = decline
    }
    
    func setView(nextStr: String, cancelStr: String, icons: UIImage) {
        self.nextBtn.setTitle(nextStr, for: .normal)
        self.cancelBtn.setTitle(cancelStr, for: .normal)
        self.icon.image = icons
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func continueAction(_ sender: Any) {
       continueAction()
        
    }
    @IBAction func declineAction(_ sender: Any) {
        declineAction()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let dist = [0, 30, 24, 17, 8]
        self.cancelBtn.setTitleColor(color, for: .normal)
        self.nextBtn.setTitleColor(SDKColors.MidGray, for: .normal)
        for i in 1...4 {
            let view = UIView()
            self.errorView.addSubview(view)
            view.tag = i
            self.constSetters(view, to: errorView, const: CGFloat(dist[i]))
            let frame = CGRect(x: self.errorView.frame.origin.x - CGFloat(dist[i]),
                               y: self.errorView.frame.origin.y - CGFloat(dist[i]),
                               width: self.errorView.frame.width - CGFloat(dist[i]*2),
                               height: self.errorView.frame.height - CGFloat(dist[i]*2))
            view.frame = frame
            
            view.layer.masksToBounds = true
            view.layer.cornerRadius = frame.width/2
            view.center = self.errorView.center
            view.layer.borderWidth = CGFloat(2 + Double(i) * 0.7)
            view.layer.borderColor = color.withAlphaComponent( CGFloat(1 - Double(5-i) * 0.1)).cgColor
            
            leftBottomView.layer.masksToBounds = true
            leftBottomView.layer.cornerRadius = leftBottomView.frame.width/2
            leftBottomView.layer.borderWidth = 2
            leftBottomView.layer.borderColor = color.cgColor
            
            rightBottomView.layer.masksToBounds = true
            rightBottomView.layer.cornerRadius = rightBottomView.frame.width/2
            rightBottomView.layer.borderWidth = 2
            rightBottomView.layer.borderColor = color.cgColor
            
        }
        
    }
    
    func constSetters(_ view: UIView, to parent: UIView, const: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.topAnchor.constraint(equalTo: view.topAnchor, constant: -const).isActive = true
        parent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -const).isActive = true
        parent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: const).isActive = true
        parent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: const).isActive = true
    }
}
