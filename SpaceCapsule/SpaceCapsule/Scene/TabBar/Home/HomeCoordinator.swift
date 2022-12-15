//
//  HomeCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class HomeCoordinator: Coordinator, MovableToCapsuleAccess {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

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

    func tabBarAppearance(isHidden: Bool) {
        guard let parent = parent as? TabBarCoordinator else {
            return
        }

        parent.tabBarAppearance(isHidden: isHidden)
    }
}
