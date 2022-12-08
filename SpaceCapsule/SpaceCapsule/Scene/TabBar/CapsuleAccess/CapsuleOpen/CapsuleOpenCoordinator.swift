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
    var capsuleCellItem: ListCapsuleCellItem?

    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let capsuleOpenViewController = CapsuleOpenViewController()
        let capsuleOpenViewModel = CapsuleOpenViewModel()
        if let capsuleCellItem = capsuleCellItem {
            capsuleOpenViewModel.capsuleCellItem = capsuleCellItem
        }
        capsuleOpenViewModel.coordinator = self
        capsuleOpenViewController.viewModel = capsuleOpenViewModel
        
        navigationController?.pushViewController(capsuleOpenViewController, animated: true)
    }

    func finish() {
        _ = parent?.children.popLast()
    }

    func moveToCapsuleDetail() {
        guard let parent = parent as? CapsuleAccessCoordinator else {
            return
        }
 
        parent.moveToCapsuleDetail()
    }
    
    func hideTabBar() {
        guard let parent = parent as? CapsuleAccessCoordinator else {
            return
        }
        
        parent.hideTabBar()
    }
}
