//
//  MovableToCapsuleAccess.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/12.
//

import Foundation

protocol MovableToCapsuleAccess {
    func moveToCapsuleAccess(with: ListCapsuleCellItem)
}

extension Coordinator where Self: MovableToCapsuleAccess {
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
}
