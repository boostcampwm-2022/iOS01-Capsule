//
//  CapsuleLocateCoordinator.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/15.
//

import UIKit

final class CapsuleLocateCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let capsuleLocateViewController = CapsuleLocateViewController()
        let capsuleLocateViewModel = CapsuleLocateViewModel()

        capsuleLocateViewModel.coordinator = self
        capsuleLocateViewController.viewModel = capsuleLocateViewModel
        capsuleLocateViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = capsuleLocateViewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        navigationController?.present(capsuleLocateViewController, animated: true)
    }
    
    func finish() {
        parent?.children.popLast()
    }
}
