//
//  CapsuleMapCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class CapsuleMapCoordinator: Coordinator, MovableToCapsuleAccess {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    init() {
        navigationController = .init()
    }

    func start() {
        let capsuleMapViewModel = CapsuleMapViewModel()
        let capsuleMapViewController = CapsuleMapViewController()

        capsuleMapViewModel.coordinator = self
        capsuleMapViewController.viewModel = capsuleMapViewModel

        navigationController?.setViewControllers([capsuleMapViewController], animated: true)
    }
    
    func tabBarAppearance(isHidden: Bool) {
        guard let parent = parent as? TabBarCoordinator else {
            return
        }

        parent.tabBarAppearance(isHidden: isHidden)
    }
}
