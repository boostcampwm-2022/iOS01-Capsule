//
//  CapsuleAccessCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation

final class CapsuleAccessCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?
    
    var capsuleCellItem: ListCapsuleCellItem?

    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        moveToCapsuleOpen()
    }

    func moveToCapsuleOpen() {
        let capsuleOpenCoordinator = CapsuleOpenCoordinator(navigationController: navigationController)
        capsuleOpenCoordinator.capsuleCellItem = capsuleCellItem
        capsuleOpenCoordinator.parent = self
        capsuleOpenCoordinator.start()
        children.append(capsuleOpenCoordinator)
    }

    func moveToCapsuleDetail() {
        let capsuleDetailCoordinator = CapsuleDetailCoordinator(navigationController: navigationController)
        capsuleDetailCoordinator.parent = self
        capsuleDetailCoordinator.capsuleUUID = capsuleCellItem?.uuid
        capsuleDetailCoordinator.start()
        
        children.append(capsuleDetailCoordinator)
    }
    
    func finish() {
        if let parent = parent?.parent as? TabBarCoordinator {
            parent.tabBarWillHide(false)
        }
    }
}
