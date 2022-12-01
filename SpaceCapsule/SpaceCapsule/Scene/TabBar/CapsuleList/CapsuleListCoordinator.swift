//
//  CapsuleListCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

final class CapsuleListCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    var disposeBag = DisposeBag()
    var sortPolicyObserver = BehaviorRelay<SortPolicy>(value: .nearest)

    init() {
        navigationController = .init()
    }

    func start() {
        let capsuleListViewController = CapsuleListViewController()
        let capsuleListViewModel = CapsuleListViewModel()

        capsuleListViewModel.coordinator = self
        capsuleListViewController.viewModel = capsuleListViewModel
        capsuleListViewModel.input.sortPolicy = sortPolicyObserver
        capsuleListViewController.viewModel?.input.sortPolicy = sortPolicyObserver

        navigationController?.setViewControllers([capsuleListViewController], animated: true)
        navigationController?.navigationBar.topItem?.title = "목록"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.themeFont(ofSize: FrameResource.fontSize120) as Any]
    }

    func moveToCapsuleAccess(capsuleCellModel: ListCapsuleCellModel) {
        let capsuleAccessCoordinator = CapsuleAccessCoordinator(navigationController: navigationController)
        capsuleAccessCoordinator.capsuleCellModel = capsuleCellModel
        capsuleAccessCoordinator.parent = self
        capsuleAccessCoordinator.start()

        children.append(capsuleAccessCoordinator)

        if let parent = parent as? TabBarCoordinator {
            parent.tabBarWillHide(true)
        }

//        let capsuleOpenCoordinator = CapsuleOpenCoordinator(navigationController: navigationController)
//        capsuleOpenCoordinator.capsuleCellModel = capsuleCellModel
//        capsuleOpenCoordinator.parent = self
//        capsuleOpenCoordinator.start()
//
//        children.append(capsuleOpenCoordinator)
//
//        if let parent = parent as? TabBarCoordinator {
//            parent.tabBarWillHide(true)
//        }
    }

    func showSortPolicySelection(sortPolicy: SortPolicy) {
        let sortPolicySelectionCoordinator = SortPolicySelectionCoordinator(navigationController: navigationController)

        sortPolicySelectionCoordinator.currentSortPolicy = sortPolicy
        sortPolicySelectionCoordinator.parent = self
        sortPolicySelectionCoordinator.start()

        children.append(sortPolicySelectionCoordinator)
    }
}
