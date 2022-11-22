//
//  CapsuleCloseCoordinator.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/15.
//

import UIKit

class CapsuleCloseCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let capsuleCloseViewController = CapsuleCloseViewController()
        let capsuleCloseViewModel = CapsuleCloseViewModel()

        capsuleCloseViewModel.coordinator = self
        capsuleCloseViewController.viewModel = capsuleCloseViewModel

        navigationController?.pushViewController(capsuleCloseViewController, animated: true)
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
