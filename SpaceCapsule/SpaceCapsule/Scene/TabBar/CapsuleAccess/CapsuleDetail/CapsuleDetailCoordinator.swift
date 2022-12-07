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

        capsuleDetailViewModel.fetchCapsule(with: capsuleUUID)

        navigationController?.pushViewController(capsuleDetailViewController, animated: true)

        // MARK: 목록으로 이동

        if let rootVC = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootVC, capsuleDetailViewController]
        }

        setupNavigationItem()
    }

    private func setupNavigationItem() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.themeFont(ofSize: FrameResource.fontSize100) as Any]

        let backButton = UIBarButtonItem()
        backButton.title = "목록"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    func finish() {
        _ = parent?.children.popLast()

        if let parent = parent as? CapsuleAccessCoordinator {
            parent.finish()
        }
    }
}
