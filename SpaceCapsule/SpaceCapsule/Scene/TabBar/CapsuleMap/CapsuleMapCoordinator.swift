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
    
    func moveToCapsuleAccess(uuid: String) {
        let capsuleAccessCoordinator = CapsuleAccessCoordinator(navigationController: navigationController)

        if let capsule = AppDataManager.shared.capsule(uuid: uuid) {
            let capsuleCellItem = ListCapsuleCellItem(
                uuid: capsule.uuid,
                thumbnailImageURL: capsule.images.first,
                address: capsule.address,
                closedDate: capsule.closedDate,
                memoryDate: capsule.memoryDate,
                coordinate: capsule.geopoint.coordinate
            )
            
            capsuleAccessCoordinator.capsuleCellItem = capsuleCellItem
        }
        
        capsuleAccessCoordinator.parent = self
        capsuleAccessCoordinator.start()

        children.append(capsuleAccessCoordinator)

        if let parent = parent as? TabBarCoordinator {
            parent.tabBarWillHide(true)
        }
    }
}
