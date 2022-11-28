//
//  UIViewController.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/24.
//

import UIKit

// dismiss keyboard
extension UIViewController {
    private var tapGestureRecognizer: UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false

        return tap
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func addTapGestureRecognizer() {
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func removeTapGestureRecognizer() {
        view.removeGestureRecognizer(tapGestureRecognizer)
    }
}
