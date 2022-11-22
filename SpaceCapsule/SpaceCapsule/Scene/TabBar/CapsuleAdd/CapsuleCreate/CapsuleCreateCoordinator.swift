//
//  CapsuleCreateCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class CapsuleCreateCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        showCapsuleCreate()
    }

    func showCapsuleCreate() {
        let capsuleCreateViewController = CapsuleCreateViewController()
        let capsuleCreateViewModel = CapsuleCreateViewModel()

        capsuleCreateViewModel.coordinator = self
        capsuleCreateViewController.viewModel = capsuleCreateViewModel

        navigationController?.setViewControllers([capsuleCreateViewController], animated: true)
    }

    func showDatePicker() {
        let datePickerCoordinator = DatePickerCoordinator(navigationController: navigationController)
        datePickerCoordinator.parent = self
        datePickerCoordinator.start()
        
        children.append(datePickerCoordinator)
    }
    
    func showCapsuleLocate() {
        let capsuleLocateCoordinator = CapsuleLocateCoordinator(navigationController: navigationController)
        capsuleLocateCoordinator.parent = self
        capsuleLocateCoordinator.start()
        
        children.append(capsuleLocateCoordinator)
    }

    func finish() {
        parent?.navigationController?.dismiss(animated: true)
    }
}
