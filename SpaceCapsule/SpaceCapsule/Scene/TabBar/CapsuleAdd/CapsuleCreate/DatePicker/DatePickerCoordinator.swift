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
    var navigationController: CustomNavigationController?

    var selectedDate: Date?

    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let datePickerViewController = DatePickerViewController()
        let datePickerViewModel = DatePickerViewModel()

        datePickerViewModel.coordinator = self
        datePickerViewController.viewModel = datePickerViewModel
        datePickerViewController.configure(date: selectedDate)
        datePickerViewController.modalPresentationStyle = .pageSheet

        if let sheet = datePickerViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        navigationController?.present(datePickerViewController, animated: true)
    }

    func done(date: Date) {
        guard let parent = parent as? CapsuleCreateCoordinator else {
            return
        }

        parent.date?.onNext(date)
        parent.children.popLast()
    }
}
