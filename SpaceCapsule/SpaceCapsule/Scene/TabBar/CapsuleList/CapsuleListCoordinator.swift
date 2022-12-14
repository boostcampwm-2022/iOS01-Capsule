//
//  CapsuleListCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

final class CapsuleListCoordinator: Coordinator, MovableToCapsuleAccess {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    var disposeBag = DisposeBag()
    var sortPolicyObserver = BehaviorRelay<SortPolicy>(value: .nearest)

    init() {
        navigationController = .init()
    }

    func start() {
        moveToCapsuleList()
    }

    func moveToCapsuleList() {
        let capsuleListViewController = CapsuleListViewController()
        let capsuleListViewModel = CapsuleListViewModel()
        capsuleListViewModel.coordinator = self
        capsuleListViewController.viewModel = capsuleListViewModel
        capsuleListViewModel.input.sortPolicy = sortPolicyObserver
        capsuleListViewController.viewModel?.input.sortPolicy = sortPolicyObserver
        navigationController?.setViewControllers([capsuleListViewController], animated: true)

        setUpNavigationItem()
    }

    private func setUpNavigationItem() {
        navigationController?.navigationBar.topItem?.title = "목록"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.themeFont(ofSize: FrameResource.fontSize120) as Any]
    }

    func showSortPolicySelection(sortPolicy: SortPolicy) {
        let sortPolicySelectionCoordinator = SortPolicySelectionCoordinator(navigationController: navigationController)

        sortPolicySelectionCoordinator.currentSortPolicy = sortPolicy
        sortPolicySelectionCoordinator.parent = self
        sortPolicySelectionCoordinator.start()

        children.append(sortPolicySelectionCoordinator)
    }

    func tabBarAppearance(isHidden: Bool) {
        guard let parent = parent as? TabBarCoordinator else {
            return
        }

        parent.tabBarAppearance(isHidden: isHidden)
    }
}
