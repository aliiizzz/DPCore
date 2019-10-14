//
//  DPMaterialTextField.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-22.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit

enum DPMaterialTextFieldType {
    case success
    case normal
    case error
    case disabled
}

@IBDesignable
class DPMaterialTextField: UIControl, UITextFieldDelegate {
    
    var isResponseToCopyPaste: Bool = true {
        didSet {
            textField.isResponseToCopyPaste = isResponseToCopyPaste
        }
    }
    
    @IBInspectable
    var corner: CGFloat = 2.0 {
        didSet {
            textField.layer.cornerRadius = corner
            update()
            
        }
    }
    var maxLength: Int = 100
    
    var textFieldType: DPMaterialTextFieldType = .normal {
        didSet {
            switch textFieldType {
            case .error:
                borderColors = SDKColors.secondary
            case .success:
                break
            case .normal:
                borderColors = SDKColors.primaryLight
            case .disabled:
                borderColors = UIColor(hexStr: "#808080")
            }
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    var borderColors: UIColor = .black {
        didSet {
            textField.layer.borderColor = borderColors.cgColor
            hintLabel.textColor = borderColors
            placeholderLabel.textColor = borderColors
            update()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 1.0 {
        didSet {
            textField.layer.borderWidth = borderWidth
            update()
        }
    }
    
    @IBInspectable
    var placeholderPaddingSize: Float = 16.0 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(placeholderPaddingSize), height: self.textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
    }
    
    @IBInspectable
    var textFieldHeight: CGFloat = 48.0 {
        didSet {
            
            guard textFieldHeight != oldValue else { return}
            heightConstraint.constant = textFieldHeight
            update()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable
    var hintText: String? = "" {
        didSet {
            
            UIView.performWithoutAnimation {
                
                let paraghraphStyle = NSMutableParagraphStyle()
                
                switch semanticContentAttribute {
                case .forceRightToLeft:
                    paraghraphStyle.alignment = .right
                case .forceLeftToRight:
                    paraghraphStyle.alignment = .left
                default:
                    paraghraphStyle.alignment = .natural
                }
                
                paraghraphStyle.minimumLineHeight = hintLabel.font.lineHeight * 0.75
                paraghraphStyle.maximumLineHeight = hintLabel.font.lineHeight * 0.75
//                paraghraphStyle.lineSpacing = 1.0
                
                if let text = hintText {
                    let attirubteText = NSAttributedString(string: text, attributes: [.font: hintLabel.font, .paragraphStyle: paraghraphStyle])
                    
                    hintLabel.attributedText = attirubteText
                    hintLabel.isHidden = false
                }
                else {
                    hintLabel.attributedText = nil
                    hintLabel.text = nil
                    hintLabel.isHidden = true
                    
                }
                invalidateIntrinsicContentSize()
            }
            
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
            
        }
    }
    @IBInspectable
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable
    var title: String? {
        didSet {
//            if isFixed {
            
                UIView.performWithoutAnimation {
                    
                    let paraghraphStyle = NSMutableParagraphStyle()
                    paraghraphStyle.alignment = .natural
                    paraghraphStyle.minimumLineHeight = placeholderLabel.font.lineHeight * 0.75
                    paraghraphStyle.maximumLineHeight = placeholderLabel.font.lineHeight * 0.75
                    
                    if let text = title {
                        let attirubteText = NSAttributedString(string: text, attributes: [.font: placeholderLabel.font, .paragraphStyle: paraghraphStyle])
                        
                        placeholderLabel.attributedText = attirubteText
                        placeholderLabel.isHidden = false
                    }
                    else {
                        placeholderLabel.attributedText = nil
                        placeholderLabel.text = nil
                        placeholderLabel.isHidden = true
                        
                    }
                    
                    invalidateIntrinsicContentSize()
                }
                
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                }
                
//            }
            
        }
    }
    
    var text: String? {
        set {
            if !newValue.isEmptyOrBlank {
                textField.clearButtonMode = .whileEditing
            }
            
            textField.text = newValue
            
            if newValue.isEmptyOrBlank {
                self.dismissTextFieldKeyboard()
            }
            
            if textFieldType != .normal {
                textFieldType = .normal
            }
            
            if isFixed {
                hintText = nil
            }
        }
        get {
            return textField.text
        }
    }
    
    @IBInspectable
    var isAccessible: Bool = true
    
    @IBInspectable
    var isFixed: Bool = true
    
    private(set) var textField: InnerTextField = InnerTextField()
    private var placeholderLabel: InnertLabel! = InnertLabel()
    private var hintLabel: UILabel! = UILabel()
    private var heightConstraint: NSLayoutConstraint!
    
    override var semanticContentAttribute: UISemanticContentAttribute {
        didSet {
            for view in subviews {
                view.semanticContentAttribute = semanticContentAttribute
            }
            setNeedsLayout()
        }
    }
    
    // MARK: - Override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderColors = UIColor.gray
//        self.placeholderLabel.frame.origin.y = self.convert(self.textField.placeholderRect(forBounds: self.textField.bounds), from: self.textField).minY
    }
    
    // MARK: - - Event Methods
    @objc func textFieldSelected(textField: DPMaterialTextField) {
        
        //dismissTextFieldKeyboard()
        self.textField.isUserInteractionEnabled = true
        
        borderColors = SDKColors.primary
        placeholderLabel.textColor = SDKColors.primary
        
        if(textField.textField.text == "" && textField.placeholderLabel.isHidden) {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState],
                           animations: {
                            self.placeholderLabel.isHidden = false
                            self.textField.placeholder = ""
                            self.placeholderLabel.frame.origin.y = 4
            }) { _ in
                
            }
            
        }
    }
    
    @objc func textEditingChanged(_ textField: InnerTextField) {
        
//        let isEditing = self.textField.isFirstResponder
//
//        switch isEditing {
//        case true:
//            textFieldSelected(textField: self)
//        default:
//            dismissTextFieldKeyboard()
//        }
    }
    
    @objc func textChanged(_ textField: UITextField) {
        
//        self.text = String((textField.text?.prefix(maxLength))!)
        self.textField.text = String((textField.text?.prefix(maxLength))!)
        // junk it should be fix
        if self.text == "" {
            self.textFieldType = .normal
            self.hintText = ""
        }
    }
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        dismissTextFieldKeyboard()
        return true
    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        dismissTextFieldKeyboard()
//    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismissTextFieldKeyboard()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textFieldSelected(textField: self)
       
        return true
    }
    
    // MARK: - Constructor Methods
    func setup() {
        
        heightConstraint = textField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        heightConstraint.isActive = true
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged(_:)), for: [.editingChanged, .valueChanged])
        placeholderLabel.text = "  test  "
        textField.textAlignment = .right
        
        textField.font = UIFont(name: "IRANYekan", size: 16)
        placeholderLabel.font = UIFont(name: "IRANYekan", size: 12)
        hintLabel.font = UIFont(name: "IRANYekan-Light", size: 12)
        
        placeholderLabel.backgroundColor = .white
        textField.layer.masksToBounds = true
        textField.borderStyle = .line
        addSubview(textField)
        addSubview(placeholderLabel)
        addSubview(hintLabel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(textFieldConst().map { $0.isActive = true; return $0 })
        self.addConstraints(hintLabelConstToView().map { $0.isActive = true; return $0 })
        self.addConstraints(placeHolderConst().map { $0.isActive = true; return $0 })
        
        textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: UIControlEvents.editingDidBegin)
        textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: UIControlEvents.editingDidEnd)
        textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: UIControlEvents.editingDidEndOnExit)
        
//        self.addTarget(self, action: #selector(textFieldSelected), for: .touchDown)
        
        placeholderLabel.contentInset = UIEdgeInsets(top: 0, left: 4,
                                                     bottom: 0, right: 4)
        
        placeholderLabel.isHidden = true
        
    }
    
    private func textFieldConst() -> [NSLayoutConstraint] {
        
        let topConstraint = textField.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 0)
        topConstraint.priority = .defaultHigh
        let leadingConstraint = textField.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 0)
        let trailingConstraint = layoutMarginsGuide.trailingAnchor.constraint(equalTo: self.textField.trailingAnchor, constant: 0)
        return [topConstraint, trailingConstraint, leadingConstraint]
    }
    
    private func hintLabelConstToView() -> [NSLayoutConstraint] {
        
        let topConstraint = hintLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4)
        let leadingConstraint = hintLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 0)
        let trailingConstraint = layoutMarginsGuide.trailingAnchor.constraint(equalTo: hintLabel.trailingAnchor, constant: 0)
        let bottomConstraint = layoutMarginsGuide.bottomAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 0)
        
        return [topConstraint, trailingConstraint, leadingConstraint, bottomConstraint]
    }
    
    private func placeHolderConst() -> [NSLayoutConstraint] {
        
        let topConstraint = placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4)
        
        let leadingConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor,
                                                                          constant: textField.paddingEdgeInset.left)
        
        let trailingConstraint = textField.trailingAnchor.constraint(greaterThanOrEqualTo: placeholderLabel.trailingAnchor,
                                                                     constant: textField.paddingEdgeInset.right)
        let bottomConstraint = textField.topAnchor.constraint(equalTo: placeholderLabel.centerYAnchor, constant: 0)
        
        return [topConstraint, trailingConstraint, leadingConstraint, bottomConstraint]
    }
    
    // MARK: - Update Method
    func update() {
        
        autoresizingMask = [UIViewAutoresizing.flexibleWidth,
                            UIViewAutoresizing.flexibleHeight]
        //        self.updateConstraints()
        //        textField.updateConstraints()
        //        placeholderLabel.updateConstraints()
        //        hintLabel.updateConstraints()
        //        invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
        
    }
    
    // MARK: - TextField Mehtod Handler
    
    func dismissTextFieldKeyboard() {
        
        textField.resignFirstResponder()
        let shouldHidePlaceHolder = (self.textField.text.isEmptyOrBlank && !self.placeholderLabel.isHidden)
        
        let borderAnimation = {
            
            if self.textFieldType != .error {
                self.borderColors = UIColor.gray
                 self.placeholderLabel.textColor = UIColor.gray
            }
           
        }
        
        guard shouldHidePlaceHolder else {
            borderAnimation()
            return
        }
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [.calculationModeLinear, .beginFromCurrentState],
                                animations: {
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.75, animations: {
                                        borderAnimation()
                                        
                                        self.placeholderLabel.frame.origin.y = self.convert(self.textField.placeholderRect(forBounds: self.textField.bounds), from: self.textField).minY + (self.placeholderLabel.frame.height / 3)
                                        
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                                        self.placeholderLabel.isHidden = true
                                        self.placeholderLabel.alpha = 0.0
                                          self.textField.placeholder = self.placeholderLabel.text
                                        
                                    })
                                    
        }, completion: { (finished) in
            guard finished else { return }
            
            self.placeholderLabel.alpha = 1.0
            self.textField.placeholder = self.placeholderLabel.text
        })
      
    }
    
}

class InnerTextField: UITextField {
    
    var isResponseToCopyPaste: Bool = true
    
    var paddingEdgeInset: UIEdgeInsets = .init(top: 5, left: 14, bottom: 5, right: 14) {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(super.textRect(forBounds: bounds), paddingEdgeInset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(super.editingRect(forBounds: bounds), paddingEdgeInset)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return self.isResponseToCopyPaste
        }
        
        return super.canPerformAction(action, withSender: send)
    }
    
    /*
     override func borderRect(forBounds bounds: CGRect) -> CGRect {
     return super.borderRect(forBounds: bounds).insetBy(dx: -5, dy: -5)
     }
     
     override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
     return super.placeholderRect(forBounds: bounds).insetBy(dx: 5, dy: 5)
     }
     
     override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
     return super.clearButtonRect(forBounds: bounds).insetBy(dx: 5, dy: 5)
     }
     
     override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
     return super.leftViewRect(forBounds: bounds).insetBy(dx: 5, dy: 0)
     }
     
     override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
     return super.rightViewRect(forBounds: bounds).insetBy(dx: 5, dy: 0)
     }
     */
}

class InnertLabel: UILabel {
    
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, contentInset))
    }
    
    override var intrinsicContentSize: CGSize {
        var superContentSize = super.intrinsicContentSize
        superContentSize.height += (contentInset.top + contentInset.bottom)
        superContentSize.width += (contentInset.left + contentInset.right)
        return superContentSize
    }
    
}
