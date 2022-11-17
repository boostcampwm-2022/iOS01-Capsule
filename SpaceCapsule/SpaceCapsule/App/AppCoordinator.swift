//
//  AppCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parent: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController?
    
    var rootViewController: UIViewController?
    
    func start() {
        // TODO: 분기처리 하기!
        // moveToAuth()
    }
    
    private func moveToAuth() {
        let navigationController = UINavigationController()
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        children.append(authCoordinator)
        authCoordinator.parent = self
        authCoordinator.start()
        rootViewController = navigationController
    }
    
    private func moveToTabBar() {
       
    }
}
