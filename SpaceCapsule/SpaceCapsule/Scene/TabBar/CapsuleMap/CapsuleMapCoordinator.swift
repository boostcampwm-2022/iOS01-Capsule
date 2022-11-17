//
//  CapsuleMapCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class CapsuleMapCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init() {
        navigationController = .init()
    }

    func start() {
        let capsuleMapViewController = CapsuleMapViewController()
        let capsuleMapViewModel = CapsuleMapViewModel()

        capsuleMapViewModel.coordinator = self
        capsuleMapViewController.viewModel = capsuleMapViewModel

        navigationController?.setViewControllers([capsuleMapViewController], animated: true)
    }
}
