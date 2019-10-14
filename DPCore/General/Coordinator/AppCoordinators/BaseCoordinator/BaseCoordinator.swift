//
//  BaseCoordinator.swift
//  DPCore
//
//  Created by Farshad Mousalou on 6/26/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Foundation

class BaseCoordinator <VC: UIViewController, RouteType: Route> : RoutableCoordinator where VC: Presentable {
    
    var childCoordinators: [Coordinator]?
    
    var parentCoordinator: Coordinator?
    
    let router: Router<VC>
    
    deinit {
        childCoordinators?.removeAll()
        parentCoordinator = nil
    }
    
    private let id = UUID()
    
    init(router: Router<VC>, parentCoordinator: ChildableCoordinator? = nil) {
        self.router = router
        self.parentCoordinator = parentCoordinator
        self.childCoordinators = []
    }
    
    // MARK: - Public methods
    func add(_ coordinator: Coordinator) {
        if childCoordinators?.first(where: { $0 === coordinator }) != nil {
            return
        }
        
        childCoordinators?.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator?) {
        
        guard childCoordinators?.isEmpty == false, let coordinator = coordinator else { return }
        
        if let val = childCoordinators?.enumerated().first(where: { $0.1 === coordinator }) {
            childCoordinators?.remove(at: val.offset)
        }
    }
    
    // MARK: - Coordinator
    func start(with route: RouteType) {
        fatalError("override this \(#function) method")
    }
    
    func start(with option: DeepLinkOption?) {
        fatalError("override this \(#function) method")
    }
    
    func navigate(to route: RouteType) {
        fatalError("override this \(#function) method")
    }
    
//    func start(with route: BaseCoordinator.RouteType) {
//        fatalError("override this \(#function) method")
//    }
//
//    func navigate(to route: BaseCoordinator.RouteType) {
//        fatalError("override this \(#function) method")
//    }
    
}

extension BaseCoordinator: Hashable, Equatable {
    
    static func == (lhs: BaseCoordinator, rhs: BaseCoordinator) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hashValue: Int {
        return id.hashValue
    }
}

extension BaseCoordinator: Presentable {
    
    var identifier: UUID {
        return id
    }
    
    var viewController: UIViewController? {
        return self.router.viewController
    }
    
    func toPresent() -> UIViewController? {
       return self.router.viewController
    }
}
