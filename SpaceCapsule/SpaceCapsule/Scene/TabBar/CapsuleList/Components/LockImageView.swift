//
//  LockImageView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/15.
//

import UIKit

final class LockImageView: UIImageView {
    init() {
        super.init(image: .lock)
        tintColor = .themeGray200
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
