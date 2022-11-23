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

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let sortPolicySelectionViewController = SortPolicySelectionViewController()
        let sortPolicySelectionViewModel = SortPolicySelectionViewModel()

        sortPolicySelectionViewModel.coordinator = self
        sortPolicySelectionViewController.viewModel = sortPolicySelectionViewModel
        sortPolicySelectionViewController.modalPresentationStyle = .pageSheet

        if let sheet = sortPolicySelectionViewController.sheetPresentationController {
            
            sheet.detents = [
                .custom { _ in
                    return 200
                }
            ]
            
            sheet.prefersGrabberVisible = true
        }

        navigationController?.present(sortPolicySelectionViewController, animated: true)
    }

    func done(dateString: String) {
        guard let parent = parent as? CapsuleListCoordinator else {
            return
        }

        // parent.dateStringObserver.onNext(dateString)
        parent.children.popLast()
    }

}
