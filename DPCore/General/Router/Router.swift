//
//  Router.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-23.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

protocol RouterProtocol: Presentable {
    
    typealias RouterProtocolCompletion = (_ viewController: UIViewController) -> Void
    
    func present(_ presenting: Presentable)
    func present(_ presenting: Presentable, animated: Bool)
    func present(_ presenting: Presentable, animated: Bool, completion: RouterProtocolCompletion?)
    
    func push(_ presenting: Presentable)
    func push(_ presenting: Presentable, transition: UIViewControllerAnimatedTransitioning?)
    func push(_ presenting: Presentable, transition: UIViewControllerAnimatedTransitioning?, animated: Bool)
    func push(_ presenting: Presentable, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, completion: RouterProtocolCompletion?)
    
    func pop()
    func pop(transition: UIViewControllerAnimatedTransitioning?)
    func pop(transition: UIViewControllerAnimatedTransitioning?, animated: Bool)
    func pop(transition: UIViewControllerAnimatedTransitioning?, animated: Bool, completion: RouterProtocolCompletion?)
    
    func dismiss()
    func dismiss(animated: Bool, completion: (() -> Void)?)
    
    func set(root presenting: Presentable)
    func set(root presenting: Presentable, hideBar: Bool, completion: RouterProtocolCompletion?)
    
    func popToRoot(animated: Bool)
    func pop(to presenting: Presentable, animated: Bool)
    
}

final class Router <T: UIViewController>: NSObject, RouterProtocol {
    
    typealias RootViewController = T
    
    // MARK: - Vars & Lets
    
    private var rootViewController: RootViewController?
    
    private var completions: [ UUID: (UIViewController) -> Void ]
    
    private weak var transition: UIViewControllerAnimatedTransitioning?
    
    // MARK: - Presentable
    
    deinit {
        self.rootViewController = nil
        self.completions.removeAll()
        self.transition = nil
    }
    
    // MARK: - Init methods
    init(rootViewController: RootViewController) {
        
        self.rootViewController = rootViewController
        self.completions = [:]
        super.init()
        
    }
    
    // MARK: - Presentable
    
    var identifier: UUID {
        return (self.rootViewController as? Presentable)?.identifier ?? UUID()
    }
    
    var viewController: UIViewController? {
        return self.rootViewController
    }
    
    func toPresent() -> UIViewController? {
        return self.viewController
    }
    
    // MARK: - RouterProtocol
    
    func present(_ presentingViewController: Presentable) {
        present(presentingViewController, animated: true)
    }
    
    func present(_ presentingViewController: Presentable, animated: Bool) {
        self.present(presentingViewController, animated: animated, completion: nil)
    }
    
    func present(_ presentingViewController: Presentable, animated: Bool, completion: RouterProtocolCompletion?) {
        
        guard let viewController = presentingViewController.viewController else {
            return
        }
        
        if let completion = completion {
            self.completions[presentingViewController.identifier] = completion
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            viewController.modalPresentationStyle = .currentContext
            viewController.preferredContentSize = CGSize(width: 375, height: 548+64)
        }
        
        self.rootViewController?.present(viewController, animated: animated, completion: nil)
    }
    
    func push(_ presentingViewController: Presentable) {
        self.push(presentingViewController, transition: nil)
    }
    
    func push(_ presentingViewController: Presentable, transition: UIViewControllerAnimatedTransitioning?) {
        self.push(presentingViewController, transition: transition, animated: true)
    }
    
    func push(_ presentingViewController: Presentable,
              transition: UIViewControllerAnimatedTransitioning?,
              animated: Bool) {
        self.push(presentingViewController, transition: transition, animated: animated, completion: nil)
    }
    
    func push(_ presentingViewController: Presentable,
              transition: UIViewControllerAnimatedTransitioning?,
              animated: Bool,
              completion: RouterProtocolCompletion?) {
        
        self.transition = transition
        guard let navController = self.rootViewController as? UINavigationController,
            let viewController = presentingViewController.viewController else {
            return
        }
        
        guard viewController !== self.rootViewController else {
            return
        }
        
        if let completion = completion {
            self.completions[presentingViewController.identifier] = completion
        }
        
        navController.pushViewController(viewController, animated: animated)
        
    }
    
    func pop() {
        self.pop(transition: nil)
    }
    
    func pop(transition: UIViewControllerAnimatedTransitioning?) {
        self.pop(transition: transition, animated: true)
    }
    
    func pop(transition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        self.pop(transition: transition, animated: animated, completion: nil)
    }
    
    func pop(transition: UIViewControllerAnimatedTransitioning?,
             animated: Bool,
             completion: RouterProtocolCompletion?) {
        
        self.transition = transition
        
        guard let navigationController = self.rootViewController as? UINavigationController,
            let topViewController = navigationController.topViewController else {
                return
        }
        
        navigationController.popViewController(animated: animated)
        
        guard let viewController = topViewController as? Presentable else {
            return
        }
        
        runCompletion(for: viewController)
        
    }
    
    func pop(to presentingViewController: Presentable, animated: Bool) {
        
        guard let navigationController = self.rootViewController as? UINavigationController,
            let foundViewController = navigationController.viewControllers.first(where: { $0 === presentingViewController.viewController }) else {
                return
        }
        
        navigationController.popToViewController(foundViewController, animated: animated)
        
    }
    
    func popToRoot(animated: Bool) {
        
        guard let navigationController = self.rootViewController as? UINavigationController else {
            return
        }
        
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            
            controllers.forEach { controller in
                guard let controller = controller as? Presentable else { return }
                self.runCompletion(for: controller)
            }
            
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        
        self.rootViewController?.dismiss(animated: animated,
                                         completion: {
                                            completion?()
        })
        
    }
    
    func set(root presentingViewController: Presentable) {
        self.set(root: presentingViewController, hideBar: false)
    }
    
    func set(root presentingViewController: Presentable, hideBar: Bool, completion: RouterProtocolCompletion? = nil) {
        
        guard let viewController = presentingViewController.viewController else { return }
        
        guard let navigationController = self.rootViewController as? UINavigationController else { return }
        
        self.popToRoot(animated: false)
        
        if let completion = completion {
            self.completions[presentingViewController.identifier] = completion
        }
        
        UIView.performWithoutAnimation {
            navigationController.viewControllers = [viewController]
        }
        
        navigationController.isNavigationBarHidden = hideBar
        
    }
    
    // MARK: - Private methods
    
    private func runCompletion(for presentable: Presentable) {
        
        for (key, completion) in self.completions {
            
            if key == presentable.identifier, let viewController = presentable.viewController {
                completion(viewController)
                self.completions[key] = nil
            }
            
        }
        
    }
   
}

// MARK: - Extensions
// MARK: - UINavigationControllerDelegate

//extension Router where T: UINavigationController : UINavigationControllerDelegate {
//
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return self.transition
//    }
//
//}
//
//extension Router: UITabBarControllerDelegate {
//
//}
