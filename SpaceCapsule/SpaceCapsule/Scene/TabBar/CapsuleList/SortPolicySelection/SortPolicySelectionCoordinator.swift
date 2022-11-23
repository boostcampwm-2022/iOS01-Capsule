//
//  SortPolicySelectionCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/23.
//

import UIKit

final class SortPolicySelectionCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let sortPolicySelectionViewController = SortPolicySelectionViewController()
        let sortPolicySelectionViewModel = SortPolicySelectionViewModel()

        sortPolicySelectionViewModel.coordinator = self
        sortPolicySelectionViewController.viewModel = sortPolicySelectionViewModel

        navigationController?.setViewControllers([sortPolicySelectionViewController], animated: true)
    }

}
