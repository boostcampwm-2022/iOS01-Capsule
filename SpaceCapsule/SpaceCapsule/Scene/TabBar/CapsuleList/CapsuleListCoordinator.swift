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
    var navigationController: UINavigationController?

    init() {
        navigationController = .init()
    }

    func start() {
        let capsuleListViewController = CapsuleListViewController()
        let capsuleListViewModel = CapsuleListViewModel()

        capsuleListViewController.viewModel = capsuleListViewModel
        capsuleListViewModel.coordinator = self
        navigationController?.setViewControllers([capsuleListViewController], animated: true)
    }

    func showCapsuleOpen() {
        let capsuleOpenViewController = CapsuleOpenViewController()
        navigationController?.pushViewController(capsuleOpenViewController, animated: true)

        if let parent = parent as? TabBarCoordinator {
            parent.tabBarWillHide(true)
        }
    }

    func finish() {
    }
}
