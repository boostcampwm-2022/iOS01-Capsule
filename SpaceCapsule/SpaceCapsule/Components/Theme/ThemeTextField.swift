//
//  ThemeTextField.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/18.
//

import UIKit

class ThemeTextField: UITextField {
    convenience init(placeholder: String) {
        self.init()
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.themeGray200 as Any]
        )
        
        textColor = .themeBlack
        layer.borderColor = UIColor.themeGray300?.cgColor
        layer.borderWidth = FrameResource.commonBorderWidth
        layer.cornerRadius = FrameResource.commonCornerRadius
        font = .themeFont(ofSize: FrameResource.fontSize100)
        backgroundColor = .themeGray100

        insertPadding()
    }

    private func insertPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftView = paddingView
        leftViewMode = ViewMode.always
    }
}
