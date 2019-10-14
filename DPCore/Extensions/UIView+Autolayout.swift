//
//  UIView+Autolayout.swift
//  DPCore
//
//  Created by Farshad Mousalou on 7/10/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation
import UIKit

internal extension UIView {
    
    /// <#Description#>
    ///
    /// - top: <#top description#>
    /// - leading: <#leading description#>
    /// - bottom: <#bottom description#>
    /// - trailing: <#trailing description#>
    /// - left: <#left description#>
    /// - right: <#right description#>
    enum Edge {
        case top
        case leading
        case bottom
        case trailing
        case left
        case right
    }
    
    /// <#Description#>
    ///
    /// - width: <#width description#>
    /// - height: <#height description#>
    enum Dimension {
        case width
        case height
    }
    
    /// <#Description#>
    ///
    /// - horizontal: <#horizontal description#>
    /// - vertical: <#vertical description#>
    enum Axis {
        case horizontal
        case vertical
    }
    
    /// <#Description#>
    ///
    /// - Parameter layoutGuide: <#layoutGuide description#>
    /// - Returns: <#return value description#>
    @available (iOS 11, *)
    @discardableResult
    func pinToSafeArea(layoutGuide: UILayoutGuide) -> [NSLayoutConstraint] {
        return addConstraints(priority: .required, { () -> [NSLayoutConstraint] in
            return [
                self.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
                self.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
                self.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
            ]
        })
    }
    
    /// <#Description#>
    ///
    /// - Parameter priority: <#priority description#>
    /// - Returns: <#return value description#>
    @discardableResult
    func pinToSuperviewEdges(inset: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        let superview = guardForSuperview()
        
        return addConstraints(priority: priority, { () -> [NSLayoutConstraint] in
            return [
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: actualInset(for: .top, value: inset.top)),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: actualInset(for: .leading, value: inset.left)),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: actualInset(for: .bottom, value: inset.bottom)),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: actualInset(for: .trailing, value: inset.right))
            ]
        })
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - edge: <#edge description#>
    ///   - inset: <#inset description#>
    ///   - priority: <#priority description#>
    /// - Returns: <#return value description#>
    @discardableResult
    func pinToSuperviewEdge(_ edge: Edge, inset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let superview = guardForSuperview()
        return pinEdge(edge, to: edge, of: superview, inset: inset, priority: priority)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - edge: <#edge description#>
    ///   - priority: <#priority description#>
    /// - Returns: <#return value description#>
    @discardableResult
    func pinToSuperviewEdge(exclude edge: Edge, inset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        let superview = guardForSuperview()
        
        return  addConstraints(priority: priority, { () -> [NSLayoutConstraint] in
            
            switch edge {
            case .top:
                return [
                    pinEdge(.leading, to: .leading, of: superview, inset: inset, priority: priority),
                    pinEdge(.bottom, to: .bottom, of: superview, inset: inset, priority: priority),
                    pinEdge(.trailing, to: .trailing, of: superview, inset: inset, priority: priority)
                ]
                
            case .leading, .left:
                return [
                    pinEdge(.top, to: .top, of: superview, inset: inset, priority: priority),
                    pinEdge(.bottom, to: .bottom, of: superview, inset: inset, priority: priority),
                    pinEdge(.trailing, to: .trailing, of: superview, inset: inset, priority: priority)
                ]
                
            case .bottom:
                
                return [
                    pinEdge(.leading, to: .leading, of: superview, inset: inset, priority: priority),
                    pinEdge(.top, to: .top, of: superview, inset: inset, priority: priority),
                    pinEdge(.trailing, to: .trailing, of: superview, inset: inset, priority: priority)
                ]
                
            case .trailing, .right:
                return [
                    pinEdge(.leading, to: .leading, of: superview, inset: inset, priority: priority),
                    pinEdge(.bottom, to: .bottom, of: superview, inset: inset, priority: priority),
                    pinEdge(.top, to: .top, of: superview, inset: inset, priority: priority)
                ]
            }
        })
        
    }
    
    @discardableResult
    func pinEdge(_ edge: Edge,
                 to otherEdge: Edge,
                 of view: UIView,
                 inset: CGFloat = 0.0,
                 priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraints = addConstraints(priority: priority, { () -> [NSLayoutConstraint] in
            switch edge {
            case .top:
                return [self.topAnchor.constraint(equalTo: yAnchor(for: otherEdge, of: view))]
            case .leading:
                return [self.leadingAnchor.constraint(equalTo: xAnchor(for: otherEdge, of: view))]
            case .bottom:
                return [self.bottomAnchor.constraint(equalTo: yAnchor(for: otherEdge, of: view))]
            case .trailing:
                return [self.trailingAnchor.constraint(equalTo: xAnchor(for: otherEdge, of: view))]
            case .left:
                return [self.leftAnchor.constraint(equalTo: xAnchor(for: otherEdge, of: view))]
            case .right:
                return [self.rightAnchor.constraint(equalTo: xAnchor(for: otherEdge, of: view))]
            }
        })
        guard let constraint = constraints.first else {
            fatalError("Failed to add constraint for some reason")
        }
        
        constraint.constant = actualInset(for: edge, value: inset)
        return constraint
    }
    
    @discardableResult
    func match(_ dimension: Dimension, of view: UIView, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraints = addConstraints(priority: priority, { () -> [NSLayoutConstraint] in
            let attribute: NSLayoutAttribute = (dimension == .width) ? .width : .height
            return [NSLayoutConstraint(item: self,
                                       attribute: attribute,
                                       relatedBy: .equal,
                                       toItem: view,
                                       attribute: attribute,
                                       multiplier: 1.0,
                                       constant: 0.0)]
        })
        return constraints.first!
    }
    
    @discardableResult
    func set(_ dimension: Dimension, to value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraints(priority: priority, { () -> [NSLayoutConstraint] in
            switch dimension {
            case .width:
                return [self.widthAnchor.constraint(equalToConstant: value)]
            case .height:
                return [self.heightAnchor.constraint(equalToConstant: value)]
            }
        }).first!
    }
    
    @discardableResult
    func alignToSuperviewAxis(_ axis: Axis, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let superview = guardForSuperview()
        
        return addConstraints(priority: priority, { () -> [NSLayoutConstraint] in
            let attribute: NSLayoutAttribute = (axis == .horizontal) ? .centerX : .centerY
            return [NSLayoutConstraint(item: self,
                                       attribute: attribute,
                                       relatedBy: .equal,
                                       toItem: superview,
                                       attribute: attribute,
                                       multiplier: 1.0,
                                       constant: 0.0)]
        }).first!
    }
    
    func setContentCompressionResistance(for axis: Axis, to priority: UILayoutPriority) {
        let axis: UILayoutConstraintAxis = (axis == .horizontal) ? .horizontal : .vertical
        self.setContentCompressionResistancePriority(priority, for: axis)
    }
    
    // MARK: Utilities
    
    private func prepareForAutoLayout(_ completion: () -> Void) {
        self.translatesAutoresizingMaskIntoConstraints = false
        completion()
    }
    
    @discardableResult
    private func addConstraints(priority: UILayoutPriority, _ completion: () -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        let constraints = completion()
        constraints.forEach({ $0.priority = priority })
        prepareForAutoLayout {
            NSLayoutConstraint.activate(constraints)
        }
        return constraints
    }
    
    private func guardForSuperview() -> UIView {
        guard let superview = self.superview else {
            fatalError("No superview for view \(self)")
        }
        return superview
    }
    
    private func actualInset(for edge: Edge, value: CGFloat) -> CGFloat {
        switch edge {
        case .trailing, .right, .bottom:
            return -value
            
        default:
            return value
        }
    }
    
    private func yAnchor(for edge: Edge, of view: UIView) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        switch edge {
        case .top:
            return view.topAnchor
        case .bottom:
            return view.bottomAnchor
        default:
            fatalError("Not a valid Y axis anchor")
        }
    }
    
    private func xAnchor(for edge: Edge, of view: UIView) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        switch edge {
        case .leading:
            return view.leadingAnchor
        case .trailing:
            return view.trailingAnchor
        case .left:
            return view.leftAnchor
        case .right:
            return view.rightAnchor
        default:
            fatalError("Not a valid X axis anchor")
        }
    }
}
