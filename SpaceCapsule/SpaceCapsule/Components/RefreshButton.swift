//
//  RefreshButton.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/07.
//

import UIKit

final class RefreshButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        tintColor = .themeBlack
        setImage(.refresh, for: .normal)
        layer.cornerRadius = FrameResource.userTrackingButtonSize / 2
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
