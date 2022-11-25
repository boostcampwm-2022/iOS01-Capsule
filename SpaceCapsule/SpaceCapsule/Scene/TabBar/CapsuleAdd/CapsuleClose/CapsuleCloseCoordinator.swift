//
//  CapsuleCloseCoordinator.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/15.
//

import UIKit

class CapsuleCloseCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let capsuleCloseViewController = CapsuleCloseViewController()
        let capsuleCloseViewModel = CapsuleCloseViewModel()

        capsuleCloseViewModel.coordinator = self
        capsuleCloseViewController.viewModel = capsuleCloseViewModel

        parent?.children.popLast()
        navigationController?.setViewControllers([capsuleCloseViewController], animated: true)
    }

    func finish() {
        parent?.children.popLast()
        navigationController?.dismiss(animated: true)
    }
}
