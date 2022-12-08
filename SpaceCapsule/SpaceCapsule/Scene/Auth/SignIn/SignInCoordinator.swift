//
//  SignInCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class SignInCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?
    
    var signInViewController: SignInViewController
    
    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
        self.signInViewController = SignInViewController()
    }
    
    func start() {
        signInViewController.viewModel = SignInViewModel(coordinator: self)
        navigationController?.pushViewController(signInViewController, animated: true)
//        navigationController?.setViewControllers([signInViewController], animated: true)
    }
    
    func didFinish() {
        _ = parent?.children.popLast()
    }
    
    func moveToNickname() {
        guard let parent = self.parent as? AuthCoordinator else {
            return
        }
        parent.moveToNickname()
        navigationController?.navigationBar.isHidden = true
    }
    
    func moveToTabBar() {
        guard let parent = self.parent as? AuthCoordinator else {
            return
        }
        parent.moveToTabBar()
    }
}
