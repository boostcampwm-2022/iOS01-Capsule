//
//  ThemeLabel.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/16.
//

import UIKit

class ThemeLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(text: String? = nil, size: CGFloat, color: UIColor?) {
        self.init()

        self.text = text
        font = .themeFont(ofSize: size)
        textColor = color
    }
}
