//
//  CapsuleCreateCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import UIKit

final class CapsuleCreateCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        showCapsuleCreate()
    }

    func showCapsuleCreate() {
        let capsuleCreateViewController = CapsuleCreateViewController()
        let capsuleCreateViewModel = CapsuleCreateViewModel()

        capsuleCreateViewModel.coordinator = self
        capsuleCreateViewController.viewModel = capsuleCreateViewModel

        navigationController?.setViewControllers([capsuleCreateViewController], animated: true)
    }

    func showDatePicker() {
        guard let parent = parent as? CapsuleAddCoordinator else {
            return
        }

        parent.showDatePicker()
    }

    func showCapsuleLocate() {
        guard let parent = parent as? CapsuleAddCoordinator else {
            return
        }

        parent.showCapsuleLocate()
    }

    func addressObserver() -> Observable<Address>? {
        guard let parent = parent as? CapsuleAddCoordinator else {
            return nil
        }

        return parent.addressObserver.asObservable()
    }

    func dateStringObserver() -> Observable<String>? {
        guard let parent = parent as? CapsuleAddCoordinator else {
            return nil
        }

        return parent.dateStringObserver.asObservable()
    }

    func finish() {
        parent?.navigationController?.dismiss(animated: true)
    }
}
