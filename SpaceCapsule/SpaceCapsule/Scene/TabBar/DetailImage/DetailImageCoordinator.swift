//
//  DetailImageCoordinator.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/06.
//

import Foundation

final class DetailImageCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    var viewController: DetailImageViewController?

    var index: Int?
    var dataArray: [Data]?

    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let detailImageViewController = DetailImageViewController()
        let detailImageViewModel = DetailImageViewModel()

        detailImageViewModel.coordinator = self
        detailImageViewController.viewModel = detailImageViewModel

        viewController = detailImageViewController

        detailImageViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(detailImageViewController, animated: false)
    }
    
    func finish() {
        viewController?.dismiss(animated: true)
    }

}
