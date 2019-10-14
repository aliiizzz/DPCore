//
//  Coordinator.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-23.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

protocol Coordinator: Presentable {}

protocol ChildableCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]? { get }
    var parentCoordinator: Coordinator? { get }

}

protocol FinishableCoordinator {
    var finish: ((Self) -> Void)? { get }
}

protocol RoutableCoordinator: ChildableCoordinator {
    
    associatedtype RouteType: Route
    
    func start(with route: RouteType)
    func start(with option: DeepLinkOption?)
    
    func navigate(to route: RouteType)
}
