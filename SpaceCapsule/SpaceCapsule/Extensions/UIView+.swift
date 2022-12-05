//
//  UIView+.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/05.
//

import UIKit

extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if isFirstResponder {
            return self
        }

        for view in subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
