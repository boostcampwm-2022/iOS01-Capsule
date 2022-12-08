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
        
        navigationController?.pushViewController(capsuleDetailViewController, animated: true)
        
        if let rootVC = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootVC, capsuleDetailViewController]
        }

        setupNavigationItem()
    }
    
    func showCapsuleSettings() {
        let capsuleSettingsCooridnator = CapsuleSettingsCoordinator(navigationController: navigationController)
        capsuleSettingsCooridnator.parent = self
        capsuleSettingsCooridnator.capsuleUUID = capsuleUUID
        capsuleSettingsCooridnator.start()
        
        children.append(capsuleSettingsCooridnator)
    }
    
    func finish() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavigationItem() {
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = "목록"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
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
