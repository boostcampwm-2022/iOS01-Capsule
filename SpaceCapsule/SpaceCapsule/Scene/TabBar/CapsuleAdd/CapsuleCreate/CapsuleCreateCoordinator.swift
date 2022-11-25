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

    var addressObserver: PublishSubject<Address>?
    var geopointObserver: PublishSubject<GeoPoint>?
    var dateStringObserver: BehaviorSubject<String>?

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

        addressObserver = capsuleCreateViewModel.input.addressObserver
        geopointObserver = capsuleCreateViewModel.input.geopointObserver
        dateStringObserver = capsuleCreateViewModel.input.dateStringObserver

        navigationController?.setViewControllers([capsuleCreateViewController], animated: true)
    }

    func showDatePicker() {
        let datePickerCoordinator = DatePickerCoordinator(navigationController: navigationController)
        datePickerCoordinator.parent = self

        if let dateString = try? dateStringObserver?.value() {
            datePickerCoordinator.selectedDate = Date.dateFormatter.date(from: dateString)
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

    func showCapsuleClose() {
        guard let parent = parent as? CapsuleAddCoordinator else {
            return
        }

        parent.showCapsuleClose()
    }

    func finish() {
        parent?.navigationController?.dismiss(animated: true)
    }

    func startIndicator() {
        guard let navigation = navigationController as? CustomNavigationController else {
            print("failed start")
            return
        }

        navigation.addIndicatorView()
    }

    func stopIndicator() {
        guard let navigation = navigationController as? CustomNavigationController else {
            print("failed stopㅎ")
            return
        }

        navigation.removeIndicatorView()
    }
}
