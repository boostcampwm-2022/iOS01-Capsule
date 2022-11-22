//
//  DatePickerCoordinator.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/22.
//

import UIKit

// TODO: - 메모리 누수??
final class DatePickerCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let datePickerViewController = DatePickerViewController()
        let datePickerViewModel = DatePickerViewModel()

        datePickerViewModel.coordinator = self
        datePickerViewController.viewModel = datePickerViewModel
        datePickerViewController.modalPresentationStyle = .pageSheet

        if let sheet = datePickerViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        navigationController?.present(datePickerViewController, animated: true)
    }

    func done(dateString: String) {
        guard let parent = parent as? CapsuleAddCoordinator else {
            return
        }

        parent.dateStringObserver.onNext(dateString)
        parent.children.popLast()
    }
}
