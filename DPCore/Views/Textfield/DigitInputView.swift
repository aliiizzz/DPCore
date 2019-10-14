//
//  DigitInputView.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-07-25.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit
//import RxSwift

enum DigitInputViewAnimationType: Int {
    case none, dissolve, spring
}

protocol DigitInputViewDelegate: class {
    func digitsDidChange(digitInputView: DigitInputView)
    func configureDigit( digitView: DigitInputView, digit: String, at index: Int) -> String
    func didSetDigit(_ digitView: DigitInputView, at index: Int)
}

enum DigiInputViewType {
    case normal, error, disabled
}

@IBDesignable
class DigitInputView: UIView {
    
    var canDismisskeyboard: Bool = true
    
    /**
     The number of digits to show, which will be the maximum length of the final string
     */
     var hint: String = "" {
        didSet {
            self.hintLabel.text = hint
            
        }
    }
    private let hintLabel: UILabel = UILabel()
    var text_rx: String = ""
    
    @IBInspectable
     var numberOfDigits: Int = 4 {
        
        didSet {
            setup()
        }
        
    }
    
    /**
     The color of the line under each digit
     */
    
    @IBInspectable
     var bottomBorderColor: UIColor = UIColor.lightGray {
        
        didSet {
            setup()
        }
        
    }
    
     var digiInputType: DigiInputViewType = .normal {
        didSet {
            switch digiInputType {
            case .normal:
                hint = ""
                for underline in underlines {
                    underline.backgroundColor = bottomBorderColor
                }
                
                let nextIndex = text.count + 1
                if labels.count > 0, nextIndex < labels.count + 1 {
                    // set the next digit bottom border color
                    let item = underlines[nextIndex - 1]
                    item.backgroundColor = nextDigitBottomBorderColor
                }
                break
            case .error:
                for item in underlines {
                    item.backgroundColor = UIColor(hexStr: "#ff4c6a")
                }
                
                break
            default:
                break
            }
        }
    }
    
    /**
     The color of the line under next digit
     */
    
    @IBInspectable
     var nextDigitBottomBorderColor: UIColor = UIColor.gray {
        
        didSet {
            setup()
        }
        
    }
    
    /**
     The color of the digits
     */
    @IBInspectable
     var textColor: UIColor = .black {
        
        didSet {
            setup()
        }
        
    }
    
    /**
     If not nil, only the characters in this string are acceptable. The rest will be ignored.
     */
    @IBInspectable
     var acceptableCharacters: String?
    
    /**
     The keyboard type that shows up when entering characters
     */
     var keyboardType: UIKeyboardType = .default {
        
        didSet {
            setup()
        }
        
    }
    
    /**
     Keyboard appearance type. `default` or `light`, `dark` and `alert`.
     */
     var keyboardAppearance: UIKeyboardAppearance = .default {
        
        didSet {
            setup()
        }
        
    }
    
    /// The animatino to use to show new digits
     var animationType: DigitInputViewAnimationType = .spring
    
    /**
     The font of the digits. Although font size will be calculated automatically.
     */
    @IBInspectable
    var font: UIFont? = UIFont(name: "IRANYekan", size: 13) {
        didSet {
            
        }
    }
    
    /**
     The string that the user has entered
     */
     var text: String {
        
        get {
            guard let textField = textField else { return "" }
            return textField.text ?? ""
        }
        
    }
    
     weak var delegate: DigitInputViewDelegate?
    
    fileprivate var labels = [UILabel]()
    fileprivate var underlines = [UIView]()
    var textField: UITextField?
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer?
    
    @IBInspectable
    var underlineHeight: CGFloat = 4
    fileprivate var spacing: CGFloat = 16
    
    override var canBecomeFirstResponder: Bool {
            return textField?.canBecomeFirstResponder ?? true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [UIViewAutoresizing.flexibleWidth,
                            UIViewAutoresizing.flexibleHeight]
        self.font = UIFont(name: "IRANYekan", size: 13)
         self.addSubview(hintLabel)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        autoresizingMask = [UIViewAutoresizing.flexibleWidth,
                            UIViewAutoresizing.flexibleHeight]
        self.font = UIFont(name: "IRANYekan", size: 13)
        self.addSubview(hintLabel)
        setup()
        
    }
    
    override func becomeFirstResponder() -> Bool {
        
        guard let textField = textField else { return false }
        return textField.becomeFirstResponder()
//        return true
        
    }
    
    override func resignFirstResponder() -> Bool {
        
        guard let textField = textField else { return true }
        return textField.resignFirstResponder()
//        return true
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // width to height ratio
        let ratio: CGFloat = 1
        
        // Now we find the optimal font size based on the view size
        // and set the frame for the labels
        var characterWidth = frame.height * ratio
        var characterHeight = frame.height
        
        // if using the current width, the digits go off the view, recalculate
        // based on width instead of height
        if (characterWidth + spacing) * CGFloat(numberOfDigits) + spacing > frame.width {
            characterWidth = (frame.width - spacing * CGFloat(numberOfDigits + 1)) / CGFloat(numberOfDigits)
            characterHeight = characterWidth / ratio
        }
        
        let extraSpace = frame.width - CGFloat(numberOfDigits - 1) * spacing - CGFloat(numberOfDigits) * characterWidth
        
        // font size should be less than the available vertical space
        let fontSize = characterHeight * 0.8
        
        let y = (frame.height - characterHeight) / 2
        for (index, label) in labels.enumerated() {
            let x = extraSpace / 2 + (characterWidth + spacing) * CGFloat(index)
            label.frame = CGRect(x: x, y: y, width: characterWidth, height: characterHeight)
            
            underlines[index].frame = CGRect(x: x, y: frame.height - underlineHeight, width: characterWidth, height: underlineHeight)
            
            if let font = font {
                label.font = font.withSize(fontSize)
            }
            else {
                label.font = label.font.withSize(fontSize)
            }
        }
        
    }
    
    @objc fileprivate func textHasBeenChanged(_ textField: UITextField) {
        //print(textField.text)
        self.didChange(true)
        self.text_rx = self.text
        self.digiInputType = .normal
    }
    /**
     Sets up the required views
     */
    fileprivate func setup() {
        
        isUserInteractionEnabled = true
        clipsToBounds = true
        
        if tapGestureRecognizer == nil {
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
            tapGestureRecognizer?.cancelsTouchesInView = false
            addGestureRecognizer(tapGestureRecognizer!)
        }
        
        if textField == nil {
            textField = UITextField()
            //textField?.inputView = UIView(frame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
            textField?.delegate = self
            textField?.addTarget(self, action: #selector(textHasBeenChanged(_:)), for: .editingChanged)
            textField?.isHidden = true
            addSubview(textField!)
            if let textField = textField {
                constSetter(textField, to: self, const: 16.0)
            }
        }
        else {
            self.textField?.delegate = self
        }
        
        textField?.keyboardType = .numberPad
        textField?.keyboardAppearance = keyboardAppearance
        
        // Since this function isn't called frequently, we just remove everything
        // and recreate them. Don't need to optimize it.
        
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll()
        
        for underline in underlines {
            underline.removeFromSuperview()
        }
        underlines.removeAll()
        
        for i in 0..<numberOfDigits {
            let label = UILabel()
            label.textAlignment = .center
            label.isUserInteractionEnabled = false
            label.textColor = textColor
            
            let underline = UIView()
            underline.backgroundColor = i == 0 ? nextDigitBottomBorderColor : bottomBorderColor
            
            addSubview(label)
            addSubview(underline)
            labels.append(label)
            underlines.append(underline)
        }
        
    }
    
    /**
     Handles tap gesture on the view
     */
    @objc fileprivate func viewTapped(_ sender: UITapGestureRecognizer) {
        
        textField!.becomeFirstResponder()
        
    }
    
    /**
     Called when the text changes so that the labels get updated
     */
    fileprivate func didChange(_ backspaced: Bool = false) {
        
        guard let textField = textField, let text = textField.text else {
            text_rx = ""
            return }
        
        for item in labels {
            item.text = ""
        }
        
        for (index, item) in text.enumerated() {
            if labels.count > index {
                let animate = index == text.count - 1 && !backspaced
                changeText(of: labels[index], newText: String(item), at: index, animated: animate)
                delegate?.didSetDigit(self, at: index)
            }
        }
        
        // set all the bottom borders color to default
        for underline in underlines {
            underline.backgroundColor = bottomBorderColor
        }
        
        let nextIndex = text.count + 1
        if labels.count > 0, nextIndex < labels.count + 1 {
            // set the next digit bottom border color
            let item = underlines[nextIndex - 1]
            item.backgroundColor = nextDigitBottomBorderColor
        }
        
         text_rx = text
        delegate?.digitsDidChange(digitInputView: self)
    }
    
    /// Changes the text of a UILabel with animation
    ///
    /// - parameter label: The label to change text of
    /// - parameter newText: The new string for the label
    private func changeText(of label: UILabel, newText: String, at index: Int, animated: Bool = false) {
        
        let newText = delegate?.configureDigit(digitView: self, digit: newText, at: index) ?? newText
        
        if !animated || animationType == .none {
            label.text = newText
            return
        }
        
        if animationType == .spring {
            label.frame.origin.y = frame.height
            label.text = newText
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                label.frame.origin.y = self.frame.height - label.frame.height
            }, completion: nil)
        }
        else if animationType == .dissolve {
            UIView.transition(with: label,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                label.text = newText
            }, completion: nil)
        }
    }
    
}

// MARK: TextField Delegate
extension DigitInputView: UITextFieldDelegate {
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return canDismisskeyboard
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: .utf8)
        let isBackSpace = strcmp(char, "\\b")
        if isBackSpace == -92 {
            textField.text!.removeLast()
            didChange(true)
            return false
        }
        
        if textField.text?.count ?? 0 >= numberOfDigits {
            return false
        }
       
        guard let acceptableCharacters = acceptableCharacters else {
            textField.text = (textField.text ?? "") + string
            didChange()
            return false
        }
        
        if acceptableCharacters.contains(string) {
            textField.text = (textField.text ?? "") + string
            didChange()
            return false
        }
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= numberOfDigits
        
    }
    
}
