//
//  ThemeLabel.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/16.
//

import UIKit

class ThemeLabel: UILabel {
    convenience init(text: String? = nil, size: CGFloat, color: UIColor?) {
        self.init()

        self.text = text
        font = .themeFont(ofSize: size)
        textColor = color
    }
}
