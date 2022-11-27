//
//  CapsuleLocateCoordinator.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/15.
//

import RxSwift
import UIKit

final class CapsuleLocateCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    var viewController: CapsuleLocateViewController?

    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        viewController = CapsuleLocateViewController()
        let capsuleLocateViewModel = CapsuleLocateViewModel()

        capsuleLocateViewModel.coordinator = self
        viewController?.viewModel = capsuleLocateViewModel
        viewController?.modalPresentationStyle = .pageSheet

        if let viewController,
           let sheet = viewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true

            navigationController?.present(viewController, animated: true)
        }
    }

    func finish() {
        viewController?.dismiss(animated: true)
        parent?.children.popLast()
    }

    func done(address: Address, geopoint: GeoPoint) {
        guard let parent = parent as? CapsuleCreateCoordinator else {
            return
        }

        parent.address?.onNext(address)
        parent.geopoint?.onNext(geopoint)
        finish()
    }
}
