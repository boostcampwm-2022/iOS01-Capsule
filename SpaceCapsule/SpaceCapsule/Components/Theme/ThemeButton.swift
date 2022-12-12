//
//  ThemeButton.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/12.
//

import UIKit

final class ThemeButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .themeColor200 : .themeGray200
        }
    }

    convenience init(title: String) {
        self.init()

        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .themeFont(ofSize: FrameResource.fontSize100)
        backgroundColor = .themeColor200
        layer.cornerRadius = FrameResource.commonCornerRadius
    }
}
