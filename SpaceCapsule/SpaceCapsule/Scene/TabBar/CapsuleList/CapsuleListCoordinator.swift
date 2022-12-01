//
//  CapsuleListCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift

final class CapsuleListCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?

    var disposeBag = DisposeBag()
    var sortPolicyObserver = PublishSubject<SortPolicy>()
    
    init() {
        navigationController = .init()
    }
    
    func start() {
        let capsuleListViewController = CapsuleListViewController()
        let capsuleListViewModel = CapsuleListViewModel()
        
        capsuleListViewModel.coordinator = self
        capsuleListViewController.viewModel = capsuleListViewModel
        capsuleListViewModel.input.sortPolicy = sortPolicyObserver
        capsuleListViewController.viewModel?.input.sortPolicy.onNext(.nearest)
        
        navigationController?.setViewControllers([capsuleListViewController], animated: true)
        navigationController?.navigationBar.topItem?.title = "목록"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.themeFont(ofSize: FrameResource.fontSize120) as Any]
    }
    
    func showCapsuleOpen(capsuleCellModel: CapsuleCellModel) {
        let capsuleOpenCoordinator = CapsuleOpenCoordinator(navigationController: navigationController)
        capsuleOpenCoordinator.capsuleCellModel = capsuleCellModel
        capsuleOpenCoordinator.parent = self
        capsuleOpenCoordinator.start()
        
        children.append(capsuleOpenCoordinator)
        
        if let parent = parent as? TabBarCoordinator {
            parent.tabBarWillHide(true)
        }
    }
    
    func showSortPolicySelection(sortPolicy: SortPolicy) {
        let sortPolicySelectionCoordinator = SortPolicySelectionCoordinator(navigationController: navigationController)
        
        sortPolicySelectionCoordinator.currentSortPolicy = sortPolicy
        sortPolicySelectionCoordinator.parent = self
        sortPolicySelectionCoordinator.start()
        
        children.append(sortPolicySelectionCoordinator)
    }
    
}
