//
//  CapsuleListCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift
import RxRelay

final class CapsuleListCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.themeFont(ofSize: 24) as Any]
    }
    
    func showCapsuleOpen() {
        let capsuleOpenCoordinator = CapsuleOpenCoordinator(navigationController: navigationController)
        
        capsuleOpenCoordinator.parent = self
        capsuleOpenCoordinator.start()
        
        children.append(capsuleOpenCoordinator)
        
        if let parent = parent as? TabBarCoordinator {
            parent.tabBarWillHide(true)
        }
    }
    
    func showSortPolicySelection(sortPolicy: SortPolicy) {
        let sortPolicySelectionCoordinator = SortPolicySelectionCoordinator(navigationController: navigationController)
        
        sortPolicySelectionCoordinator.lastSortPolicy = sortPolicy
        sortPolicySelectionCoordinator.parent = self
        sortPolicySelectionCoordinator.start()
        
        children.append(sortPolicySelectionCoordinator)
        
        if let parent = parent as? TabBarCoordinator {
            parent.tabBarWillHide(true)
        }
    }
    
}
