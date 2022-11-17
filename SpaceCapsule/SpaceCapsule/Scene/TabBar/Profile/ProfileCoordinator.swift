//
//  ProfileCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import UIKit

final class ProfileCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init() {
        navigationController = .init()
    }

    func start() {
        let profileViewController = ProfileViewController()
        let profileViewModel = ProfileViewModel()

        profileViewModel.coordinator = self
        profileViewController.viewModel = profileViewModel

        navigationController?.setViewControllers([profileViewController], animated: true)
    }
}
