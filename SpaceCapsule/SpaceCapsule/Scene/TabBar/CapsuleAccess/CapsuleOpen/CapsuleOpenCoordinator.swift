//
//  CapsuleOpenCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

class CapsuleOpenCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?
    var capsuleCellModel: CapsuleCellModel?

    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let capsuleOpenViewController = CapsuleOpenViewController()
        let capsuleOpenViewModel = CapsuleOpenViewModel()
        if let capsuleCellModel = capsuleCellModel {
            capsuleOpenViewModel.capsuleCellModel = capsuleCellModel
        }
        capsuleOpenViewModel.coordinator = self
        capsuleOpenViewController.viewModel = capsuleOpenViewModel

        navigationController?.pushViewController(capsuleOpenViewController, animated: true)
    }

    func finish() {
        _ = parent?.children.popLast()
        if let parent = parent as? TabBarCoordinator {
            parent.tabBarWillHide(false)
        }
    }
    
//    func moveToCapsuleDetail() {
//        let capsuleDetailCoordinator = CapsuleDetailCoordinator()
//        capsuleDetailCoordinator.parent = self
//        capsuleDetailCoordinator.start()
//
//        children.append(capsuleDetailCoordinator)
//
//        if let controller = capsuleDetailCoordinator.navigationController {
//            controller.modalPresentationStyle = .fullScreen
//            tabBarController.present(controller, animated: true)
//        }
//    }
}
