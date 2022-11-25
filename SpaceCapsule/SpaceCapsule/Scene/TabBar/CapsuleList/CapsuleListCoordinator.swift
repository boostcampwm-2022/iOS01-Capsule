//
//  CapsuleListCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class CapsuleListCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    init() {
        navigationController = .init()
    }

    func start() {
        let capsuleListViewController = CapsuleListViewController()
        let capsuleListViewModel = CapsuleListViewModel()

        capsuleListViewModel.coordinator = self
        capsuleListViewController.viewModel = capsuleListViewModel

        navigationController?.setViewControllers([capsuleListViewController], animated: true)
    }

    func showCapsuleOpen() {
        let capsuleOpenCoordinator = CapsuleOpenCoordinator(navigationController: navigationController)

        capsuleOpenCoordinator.parent = parent
        capsuleOpenCoordinator.start()

        children.append(capsuleOpenCoordinator)

        if let parent = parent as? TabBarCoordinator {
            parent.tabBarWillHide(true)
        }
    }
}
