//
//  HomeCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init() {
        navigationController = .init()
    }

    func start() {
        let homeViewController = HomeViewController()
        let homeViewModel = HomeViewModel()

        homeViewModel.coordinator = self
        homeViewController.viewModel = homeViewModel

        navigationController?.setViewControllers([homeViewController], animated: true)
    }
}
