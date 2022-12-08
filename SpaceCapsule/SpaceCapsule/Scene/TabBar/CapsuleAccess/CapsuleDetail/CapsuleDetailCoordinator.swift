//
//  CapsuleDetailCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import UIKit

final class CapsuleDetailCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    var capsuleUUID: String?

    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        moveToCapsuleDetail()
    }

    func moveToCapsuleDetail() {
        let capsuleDetailViewController = CapsuleDetailViewController()
        let capsuleDetailViewModel = CapsuleDetailViewModel()
        capsuleDetailViewModel.coordinator = self
        capsuleDetailViewController.viewModel = capsuleDetailViewModel
        
        if let rootVC = navigationController?.viewControllers.first {
            navigationController?.setViewControllers([rootVC, capsuleDetailViewController], animated: true)
        }
    }

    func showCapsuleSettings() {
        let capsuleSettingsCooridnator = CapsuleSettingsCoordinator(navigationController: navigationController)
        capsuleSettingsCooridnator.parent = self
        capsuleSettingsCooridnator.capsuleUUID = capsuleUUID
        capsuleSettingsCooridnator.start()

        children.append(capsuleSettingsCooridnator)
    }

    func showDetailImage(index: Int, urlArray: [String]) {
        let detailImageCoordinator = DetailImageCoordinator(navigationController: navigationController)
        detailImageCoordinator.parent = self
        detailImageCoordinator.index = index
        detailImageCoordinator.urlArray = urlArray
        detailImageCoordinator.start()

        children.append(detailImageCoordinator)
    }

    func finish() {
        _ = parent?.children.popLast()

        if let parent = parent as? CapsuleAccessCoordinator {
            parent.finish()
        }
    }

    func hideTabBar() {
        guard let parent = parent as? CapsuleAccessCoordinator else {
            return
        }

        parent.hideTabBar()
    }
}
