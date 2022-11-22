//
//  CapsuleAddCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class CapsuleAddCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init() {
        navigationController = .init()
    }

    func start() {
        showCapsuleCreate()
    }

    private func showCapsuleCreate() {
        let capsuleCreateCoordinator = CapsuleCreateCoordinator(navigationController: navigationController)
        capsuleCreateCoordinator.parent = self
        capsuleCreateCoordinator.start()

        children.append(capsuleCreateCoordinator)
    }
    
    private func showCapsuleLocate() {
        let capsuleLocateCoordinator = CapsuleLocateCoordinator(navigationController: navigationController)
        capsuleLocateCoordinator.parent = self
        capsuleLocateCoordinator.start()
        
        children.append(capsuleLocateCoordinator)
    }
}
