//
//  CapsuleSettingsCoordinator.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/07.
//

import UIKit

final class CapsuleSettingsCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?
    var capsuleUUID: String?
    
    var viewController: CapsuleSettingsViewController?
    
    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        viewController = CapsuleSettingsViewController()
        let capsuleSettingsViewModel = CapsuleSettingsViewModel()

        capsuleSettingsViewModel.coordinator = self
        viewController?.viewModel = capsuleSettingsViewModel
        
        if let viewController {
            navigationController?.present(viewController, animated: true)
        }
    }
}
