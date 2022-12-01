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
        capsuleDetailViewModel.getCapsule(with: capsuleUUID)
        capsuleDetailViewController.viewModel = capsuleDetailViewModel
        
        
        navigationController?.pushViewController(capsuleDetailViewController, animated: true)
    }
}
