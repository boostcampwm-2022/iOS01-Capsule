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
        let nicknameViewController = NicknameViewController()
        let nicknameViewModel = NickNameViewModel()
        let nicknameCoordinator = NicknameCoordinator(navigationController: navigationController)

        nicknameViewController.viewModel = nicknameViewModel
        nicknameViewModel.coordinator = nicknameCoordinator
        nicknameCoordinator.parent = self

        children.append(nicknameCoordinator)
        navigationController?.pushViewController(nicknameViewController, animated: true)
    }
}
