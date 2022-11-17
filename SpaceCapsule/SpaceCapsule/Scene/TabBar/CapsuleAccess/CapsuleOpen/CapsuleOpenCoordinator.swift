//
//  CapsuleOpenCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

class CapsuleOpenCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let capsuleOpenViewController = CapsuleOpenViewController()
        let capsuleOpenViewModel = CapsuleOpenViewModel()

        capsuleOpenViewModel.coordinator = self
        capsuleOpenViewController.viewModel = capsuleOpenViewModel

        navigationController?.pushViewController(capsuleOpenViewController, animated: true)
    }

    func finish() {
        parent?.children.removeLast()
        if let parent = parent as? TabBarCoordinator {
            parent.tabBarWillHide(false)
        }
    }
}
