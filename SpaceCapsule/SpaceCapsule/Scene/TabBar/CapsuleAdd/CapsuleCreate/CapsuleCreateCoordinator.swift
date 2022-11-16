//
//  CapsuleCreateCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class CapsuleCreateCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let capsuleCreateViewController = CapsuleCreateViewController()
        let capsuleCreateViewModel = CapsuleCreateViewModel()

        capsuleCreateViewController.viewModel = capsuleCreateViewModel
        capsuleCreateViewModel.coordinator = self

        navigationController?.setViewControllers([capsuleCreateViewController], animated: true)
    }

    func finish() {
        parent?.navigationController?.dismiss(animated: true)
    }
}
