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
        capsuleDetailViewController.viewModel = capsuleDetailViewModel
        
        navigationController?.pushViewController(capsuleDetailViewController, animated: true)
        
        if let rootVC = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootVC, capsuleDetailViewController]
        }
        
        setupNavigationItem()
    }
    
    func showCapsuleSettings() {
        let capsuleSettingsCooridnator = CapsuleSettingsCoordinator(navigationController: navigationController)
        capsuleSettingsCooridnator.parent = self
        capsuleSettingsCooridnator.start()
        
        children.append(capsuleSettingsCooridnator)
    }
    
    func finish() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavigationItem() {        
        let backButton = UIBarButtonItem()
        backButton.title = "목록"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
