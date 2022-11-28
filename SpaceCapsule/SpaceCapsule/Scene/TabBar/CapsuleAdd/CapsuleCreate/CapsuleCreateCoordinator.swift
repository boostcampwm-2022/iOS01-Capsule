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
    var navigationController: CustomNavigationController?

    var disposeBag = DisposeBag()

    var address: PublishSubject<Address>?
    var geopoint: PublishSubject<GeoPoint>?
    var date: BehaviorSubject<Date>?

    init(navigationController: CustomNavigationController?) {
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

        address = capsuleCreateViewModel.output.address
        geopoint = capsuleCreateViewModel.output.geopoint
        date = capsuleCreateViewModel.output.memoryDate

        navigationController?.setViewControllers([capsuleCreateViewController], animated: true)
    }

    func showDatePicker() {
        let datePickerCoordinator = DatePickerCoordinator(navigationController: navigationController)
        datePickerCoordinator.parent = self

        if let date = try? date?.value() {
            datePickerCoordinator.selectedDate = date
        } else {
            datePickerCoordinator.selectedDate = Date()
        }

        datePickerCoordinator.start()

        children.append(datePickerCoordinator)
    }

    func showCapsuleLocate() {
        let capsuleLocateCoordinator = CapsuleLocateCoordinator(navigationController: navigationController)
        capsuleLocateCoordinator.parent = self
        capsuleLocateCoordinator.start()

        children.append(capsuleLocateCoordinator)
    }

    func showCapsuleClose(capsule: Capsule) {
        guard let parent = parent as? CapsuleAddCoordinator else {
            return
        }

        parent.showCapsuleClose(capsule: capsule)
    }

    func finish() {
        parent?.navigationController?.dismiss(animated: true)
    }

    func startIndicator() {
        navigationController?.addIndicatorView()
    }

    func stopIndicator() {
        navigationController?.removeIndicatorView()
    }
}
