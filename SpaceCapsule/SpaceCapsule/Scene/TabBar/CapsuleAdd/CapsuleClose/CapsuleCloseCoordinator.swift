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

    var capsule: Capsule

    init(navigationController: CustomNavigationController?, capsule: Capsule) {
        self.navigationController = navigationController
        self.capsule = capsule
    }

    func start() {
        let capsuleCloseViewController = CapsuleCloseViewController()
        let capsuleCloseViewModel = CapsuleCloseViewModel(capsule: capsule)

        capsuleCloseViewModel.coordinator = self
        capsuleCloseViewController.viewModel = capsuleCloseViewModel

        navigationController?.setViewControllers([capsuleCloseViewController], animated: true)
    }

    func finish() {
        _ = parent?.children.popLast()
        navigationController?.dismiss(animated: true)
    }
}
