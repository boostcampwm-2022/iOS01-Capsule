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
    var navigationController: CustomNavigationController?

    var nicknameViewController: NicknameViewController
    
    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
        self.nicknameViewController = NicknameViewController()
    }

    func start() {
        nicknameViewController.viewModel = NickNameViewModel(coordinator: self)
        navigationController?.pushViewController(nicknameViewController, animated: true)
//        navigationController?.setViewControllers([nicknameViewController], animated: true)
    }

    func didFinish() {
        _ = parent?.children.popLast()
    }
    
    func moveToTabBar() {
        guard let parent = self.parent as? AuthCoordinator else { return }
        parent.moveToTabBar()
    }
}
