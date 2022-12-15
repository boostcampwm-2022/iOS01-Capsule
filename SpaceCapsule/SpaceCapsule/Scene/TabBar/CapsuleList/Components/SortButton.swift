//
//  SortButton.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/15.
//

import UIKit

final class SortButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        semanticContentAttribute = .forceRightToLeft
    }
}
