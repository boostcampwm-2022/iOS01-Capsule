//
//  AuthCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?
    
    var flow: AuthFlow = .signInFlow
    
    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        switch flow {
        case .signInFlow:
            moveToSignIn()
        case.nicknameFlow:
            moveToNickname()
        }
    }
    
    func moveToSignIn() {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        signInCoordinator.parent = self
        signInCoordinator.start()
        children.append(signInCoordinator)
    }
    
    func moveToNickname() {
        let nicknameCoordinator = NicknameCoordinator(navigationController: navigationController)
        nicknameCoordinator.parent = self
        nicknameCoordinator.start()
        children.append(nicknameCoordinator)
    }
    
    func moveToTabBar() {
        guard let parent = self.parent as? AppCoordinator else { return }
        parent.moveToTabBar()
    }
}
