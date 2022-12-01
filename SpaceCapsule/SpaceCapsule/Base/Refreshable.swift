//
//  Refreshable.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/01.
//

import RxSwift
import SnapKit
import UIKit

protocol Refreshable: UIView {
    var refreshButton: UIButton { get }

    func addRefreshButton()
}

extension Refreshable {
    func addRefreshButton() {
        refreshButton.backgroundColor = .white
        refreshButton.tintColor = .themeBlack
        refreshButton.setImage(.refresh, for: .normal)
        refreshButton.layer.cornerRadius = FrameResource.userTrackingButtonSize / 2

        addSubview(refreshButton)

        refreshButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.width.height.equalTo(FrameResource.userTrackingButtonSize)
        }
    }
}
