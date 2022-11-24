//
//  SortPolicySelectionCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/23.
//

import UIKit

final class SortPolicySelectionCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?
    var currentSortPolicy: SortPolicy = .nearest
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let sortPolicySelectionViewModel = SortPolicySelectionViewModel()
        sortPolicySelectionViewModel.coordinator = self
        let sortPolicySelectionViewController = SortPolicySelectionViewController(currentSortPolicy: currentSortPolicy)
        sortPolicySelectionViewController.viewModel = sortPolicySelectionViewModel
        
        sortPolicySelectionViewController.modalPresentationStyle = .pageSheet
        if let sheet = sortPolicySelectionViewController.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return FrameResource.sortPolicySelectionSheetHeight
                }
            ]
            sheet.prefersGrabberVisible = true
        }

        navigationController?.present(sortPolicySelectionViewController, animated: true)
    }
    
    func done(sortPolicy: SortPolicy) {
        guard let parent = parent as? CapsuleListCoordinator else {
            return
        }
        
        parent.sortPolicyObserver.onNext(sortPolicy)
        _ = parent.children.popLast()
    }

}
