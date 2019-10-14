//
//  UIView+ConstSetter.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-28.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

extension UIView {
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func constSetter(_ view: UIView, to parent: UIView, const: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.topAnchor.constraint(equalTo: view.topAnchor, constant: const).isActive = true
        parent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const).isActive = true
        parent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: const).isActive = true
        parent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: const).isActive = true
    }
    
    @discardableResult
    func fromNib<T: UIView>(topConst: CGFloat = 0.0) -> T? {
        
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutAttachAll(margin: 0, top: topConst)
        return contentView
    }
    
    /// attaches all sides of the receiver to its parent view
    func layoutAttachAll(margin: CGFloat = 0.0, top: CGFloat = 0.0) {
        let view = superview
        layoutAttachTop(to: view, margin: top)
        layoutAttachBottom(to: view, margin: margin)
        layoutAttachLeading(to: view, margin: margin)
        layoutAttachTrailing(to: view, margin: margin)
    }
    
    /// attaches the top of the current view to the given view's top if it's a superview of the current view, or to it's bottom if it's not (assuming this is then a sibling view).
    /// if view is not provided, the current view's super view is used
    @discardableResult
    func layoutAttachTop(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = view == superview
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: isSuperview ? .top : .bottom,
                                            multiplier: 1.0,
                                            constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the bottom of the current view to the given view
    @discardableResult
    func layoutAttachBottom(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: view, attribute: isSuperview ? .bottom : .top,
                                            multiplier: 1.0,
                                            constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the leading edge of the current view to the given view
    @discardableResult
    func layoutAttachLeading(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: isSuperview ? .leading : .trailing,
                                            multiplier: 1.0,
                                            constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the trailing edge of the current view to the given view
    @discardableResult
    func layoutAttachTrailing(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: isSuperview ? .trailing : .leading,
                                            multiplier: 1.0,
                                            constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
}
