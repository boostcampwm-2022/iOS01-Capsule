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

        capsuleListViewModel.coordinator = self
        capsuleListViewController.viewModel = capsuleListViewModel

        navigationController?.setViewControllers([capsuleListViewController], animated: true)
        navigationController?.navigationBar.backgroundColor = .themeBackground
        navigationController?.navigationBar.topItem?.title = "목록"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.themeFont(ofSize: 24)]
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
