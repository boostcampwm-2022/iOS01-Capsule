//
//  NicknameCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class NicknameCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    var nicknameViewController: NicknameViewController
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.nicknameViewController = NicknameViewController()
    }

    func start() {
        nicknameViewController.viewModel = NickNameViewModel(coordinator: self)
        navigationController?.pushViewController(nicknameViewController, animated: true)
//        navigationController?.setViewControllers([nicknameViewController], animated: true)
    }

    func didFinish() {
        parent?.children.popLast()
    }
    
    func moveToTabBar() {
        guard let parent = self.parent as? AuthCoordinator else { return }
        parent.moveToTabBar()
    }
}
