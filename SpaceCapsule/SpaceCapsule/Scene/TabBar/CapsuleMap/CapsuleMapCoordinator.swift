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

    func moveToCapsuleAccess(with capsuleCellItem: ListCapsuleCellItem) {
        let capsuleAccessCoordinator = CapsuleAccessCoordinator(navigationController: navigationController)
        capsuleAccessCoordinator.capsuleCellItem = capsuleCellItem

        capsuleAccessCoordinator.parent = self
        capsuleAccessCoordinator.start()

        children.append(capsuleAccessCoordinator)

        if let parent = parent as? TabBarCoordinator {
            parent.tabBarAppearance(isHidden: true)
        }
    }

    func tabBarAppearance(isHidden: Bool) {
        guard let parent = parent as? TabBarCoordinator else {
            return
        }

        parent.tabBarAppearance(isHidden: isHidden)
    }
}
