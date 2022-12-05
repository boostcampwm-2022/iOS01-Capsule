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
    var navigationController: CustomNavigationController?

    init() {
        navigationController = .init()
    }

    deinit {
        print("profileCoodinator deinit")
    }

    func start() {
        let profileViewController = ProfileViewController()
        let profileViewModel = ProfileViewModel()

        profileViewModel.coordinator = self
        profileViewController.viewModel = profileViewModel

        navigationController?.setViewControllers([profileViewController], animated: true)
        navigationController?.navigationBar.topItem?.title = "프로필"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.themeFont(ofSize: FrameResource.fontSize120) as Any]
    }

    func moveToAuth() {
        // pop to tabbar coordinator
        guard let tabCoordinator = popParentCoordinator() as? TabBarCoordinator else {
            print("to tabCoordinator error")
            return
        }
        // pop to app coordinator
        guard let appCoordinator = tabCoordinator.popParentCoordinator() as? AppCoordinator else {
            print("to appCoordinator error")
            return
        }
        appCoordinator.start()
    }
}
