//
//  CapsuleAddCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import UIKit

final class CapsuleAddCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    var disposeBag = DisposeBag()

    var addressObserver = PublishSubject<Address>()
    var dateStringObserver = PublishSubject<String>()

    init() {
        navigationController = .init()
    }

    func start() {
        showCapsuleCreate()
    }

    func showCapsuleCreate() {
        let capsuleCreateCoordinator = CapsuleCreateCoordinator(navigationController: navigationController)
        capsuleCreateCoordinator.parent = self
        capsuleCreateCoordinator.start()

        children.append(capsuleCreateCoordinator)
    }

    func showDatePicker() {
        let datePickerCoordinator = DatePickerCoordinator(navigationController: navigationController)
        datePickerCoordinator.parent = self
        datePickerCoordinator.start()

        children.append(datePickerCoordinator)
    }

    func showCapsuleLocate() {
        let capsuleLocateCoordinator = CapsuleLocateCoordinator(navigationController: navigationController)
        capsuleLocateCoordinator.parent = self
        capsuleLocateCoordinator.start()

        children.append(capsuleLocateCoordinator)
    }
}
