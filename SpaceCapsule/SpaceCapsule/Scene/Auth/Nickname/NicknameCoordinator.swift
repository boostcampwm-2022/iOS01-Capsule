//
//  NicknameCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class NicknameCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let nicknameViewController = NicknameViewController()
        let nicknameViewModel = NickNameViewModel()
        
        nicknameViewModel.coordinator = self
        nicknameViewController.viewModel = nicknameViewModel
        
        navigationController?.pushViewController(nicknameViewController, animated: true)
    }

    func didFinish() {
        parent?.children.removeLast()
    }
}
