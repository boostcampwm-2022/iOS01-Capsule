//
//  AuthCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

class AuthCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        configure()
    }

    func configure() {
        moveToSignIn()
//        moveToNickname()
    }

    func moveToSignIn() {
        let signInViewController = SignInViewController()
        navigationController?.pushViewController(signInViewController, animated: true)
    }

    func moveToNickname() {
        let nicknameCoordinator = NicknameCoordinator(navigationController: navigationController)
        nicknameCoordinator.parent = self
        nicknameCoordinator.start()

        children.append(nicknameCoordinator)
    }
}
