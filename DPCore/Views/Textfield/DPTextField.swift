//
//  DPTextField.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/20/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

@objc
protocol DPTextFieldDelegate: UITextFieldDelegate {
    
}

@available(iOS 7.0, *)
@IBDesignable
class DPTextField: UIControl, UITextFieldDelegate {
    
    private enum TextFieldState: Int {
        case active
        case inactive
        case disabled
        case filled
    }
    
    private let textField = UITextField()
    private let placeHolderLabel = UILabel()
    private let helperLabel = UILabel()
    
    private let textFieldBorderLayer = CAShapeLayer()
    
    private var _state: TextFieldState = .inactive {
        didSet {
            //update Layer
        }
    }
    
    // MARK: - Text Properties
    
    /// <#Description#>
    @IBInspectable
    var placeHolder: String? {
        get {
            return textField.placeholder
        }
        
        set {
            textField.placeholder = newValue
            placeHolderLabel.text = newValue
        }
    }
    
    var attributedPlaceholder: NSAttributedString? {
        set {
            textField.attributedPlaceholder = newValue
            placeHolderLabel.attributedText = newValue
        }
        get {
            return textField.attributedPlaceholder
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var text: String? {
        get {
            return textField.text
        }
        
        set {
            textField.text = newValue
        }
    }
    
    /// default is nil
    var attributedText: NSAttributedString? {
        set {
            textField.attributedText = newValue
        }
        get {
            return textField.attributedText
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var errorText: String? = nil {
        didSet {
            helperText = errorText
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var errorAttributeText: NSAttributedString? = nil {
        didSet {
            helperText = errorText
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var helperText: String? = nil {
        didSet {
            helperLabel.text = helperText
        }
    }
    
    // MARK: - Color Configuration Properties
    @IBInspectable
    var textColor: UIColor? {
        
        get {
            return textField.textColor
        }
        
        set {
            textField.textColor = newValue
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var activeColor: UIColor = .blue {
        didSet {
            
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var inactiveColor: UIColor = UIColor(white: 0.5, alpha: 1.0) {
        didSet {
            
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var disabledColor: UIColor = UIColor(white: 0.3, alpha: 1.0) {
        didSet {
            
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var errorColor: UIColor = .init(red: 1, green: 64.0 / 255.0, blue: 113.0 / 255.0, alpha: 1.0) {
        didSet {
            
        }
    }
    
    // MARK: - Font Configuration Properties
    
    /// font
    var font: UIFont? {
        get {
            return textField.font
        }
        set {
            textField.font = newValue
        }
    }
    
    /// default is 0.0. actual min may be pinned to something readable. used if adjustsFontSizeToFitWidth is YES
    @IBInspectable
    var minimumFontSize: CGFloat {
        get {
            return textField.minimumFontSize
        }
        set {
            textField.minimumFontSize = newValue
        }
    }
    
    /// <#Description#>
    @IBInspectable
    var activePlaceHolderFontSize: CGFloat = 12.0 {
        didSet {
            
        }
    }
    
    /// hello
    @IBInspectable
    var bottomLabelFontSize: CGFloat = 12.0 {
        didSet {
            
        }
    }
    
    /// default is NO. if YES, text will shrink to minFontSize along baseline
    @IBInspectable
    var adjustsFontSizeToFitWidth: Bool {
        get {
            return textField.adjustsFontSizeToFitWidth
        }
        set {
            textField.adjustsFontSizeToFitWidth = true
        }
    }
    
    // MARK: - Text Field Configuration properties
    
    // applies attributes to the full range of text. Unset attributes act like default values.
    var defaultTextAttributes: [String: Any] {
        get {
            return textField.defaultTextAttributes
        }
        set {
            textField.defaultTextAttributes = newValue
        }
    }
    
    // default is NSLeftTextAlignment
    var textAlignment: NSTextAlignment {
        get {
            return textField.textAlignment
        }
        set {
            textField.textAlignment = newValue
        }
    }
    
    /// default is NO which moves cursor to location clicked. if YES, all text cleared
    @IBInspectable
    var clearsOnBeginEditing: Bool {
        get {
            return textField.clearsOnBeginEditing
        }
        set {
            textField.clearsOnBeginEditing = newValue
        }
        
    }
    
    // default is nil. weak reference
    @IBOutlet
    weak var delegate: DPTextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    
    var isEditing: Bool {
        get {
            return textField.isEditing
            
        }
    }
    
    /// a boolean indicator that textField
    @IBInspectable
    var hasFooterText: Bool = false {
        didSet {
            
        }
    }
    
    @IBInspectable
    var clearButtonMode: UITextFieldViewMode {
        get {
            return textField.clearButtonMode
        }
        set {
            textField.clearButtonMode = newValue
        }
    }
    
    /// e.g. magnifying glass
    @IBOutlet weak var leftView: UIView? {
        didSet {
            textField.leftView = leftView
        }
    }
    
    /// sets when the left view shows up. default is UITextFieldViewModeNever
    var leftViewMode: UITextFieldViewMode {
        get {
            return textField.leftViewMode
        }
        set {
            textField.leftViewMode = newValue
        }
    }
    
    /// e.g. bookmarks button
    @IBInspectable
    @IBOutlet var rightView: UIView? {
        
        didSet {
            textField.leftView = leftView
        }
        
    }
    
    /// sets when the right view shows up. default is UITextFieldViewModeNever
    @IBInspectable
    var rightViewMode: UITextFieldViewMode {
        get {
            return textField.rightViewMode
        }
        set {
            textField.rightViewMode = newValue
        }
    }
    
    @IBInspectable
    var clearsOnInsertion: Bool {
        get {
            return textField.clearsOnInsertion
        }
        set {
            textField.clearsOnInsertion = newValue
        }
    }
    
    var isSecureTextEntry: Bool {
        get {
            return textField.isSecureTextEntry
        }
        set {
            textField.isSecureTextEntry = newValue
        }
    }
    
    override var semanticContentAttribute: UISemanticContentAttribute {
        didSet {
            for view in subviews {
                view.semanticContentAttribute = semanticContentAttribute
            }
            setNeedsLayout()
        }
    }
    
    deinit {
        cleanUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    // MARK: - overrides
    //    override var intrinsicContentSize: CGSize {
    //        let textFieldContentSize = textField.intrinsicContentSize
    //        return CGSize(width: textFieldContentSize.width + 8, height: textFieldContentSize.height + (16 * 2))
    //    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        invalidateIntrinsicContentSize()
    }
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        _state = .active
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        _state = .inactive
        return textField.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            view.semanticContentAttribute = semanticContentAttribute
        }
    }
    // MARK: - Public Methods
    
}

// MARK: - Private Methods
private extension DPTextField {
    
    func cleanUp() {
        
    }
    
    func commonInit() {
        self.setupTextField()
        self.isUserInteractionEnabled = true
    }
    
    func setupTextField() {
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
        #if DEBUG
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.blue.cgColor
        #endif
    }
}

// MARK: - Animations Methods
private extension DPTextField {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - duration: <#duration description#>
    ///   - timingFuncion: <#timingFuncion description#>
    ///   - animations: <#animations description#>
    func transactionAnimation(with duration: CFTimeInterval,
                              timingFuncion: CAMediaTimingFunction,
                              animations: () -> Void) {
        CATransaction.begin()
        CATransaction.disableActions()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(timingFuncion)
        animations()
        CATransaction.commit()
    }
    
}
