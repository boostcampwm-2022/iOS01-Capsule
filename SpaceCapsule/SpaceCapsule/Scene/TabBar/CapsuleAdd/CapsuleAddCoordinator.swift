//
//  CapsuleAddCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import UIKit

final class CapsuleAddCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    var disposeBag = DisposeBag()

    init() {
        navigationController = .init()
    }

    func start() {
        showCapsuleCreate()
    }

    func showCapsuleCreate() {
        let capsuleCreateCoordinator = CapsuleCreateCoordinator(navigationController: navigationController)
        capsuleCreateCoordinator.parent = self
        capsuleCreateCoordinator.start()

        children.append(capsuleCreateCoordinator)
    }
    
    func showCapsuleClose(capsule: Capsule) {
        let capsuleCloseCoordinator = CapsuleCloseCoordinator(
            navigationController: navigationController,
            capsule: capsule
        )
        
        capsuleCloseCoordinator.parent = self
        capsuleCloseCoordinator.start()
        
        children.popLast()
        children.append(capsuleCloseCoordinator)
    }
}
