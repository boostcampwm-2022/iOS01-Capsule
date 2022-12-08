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
    var refreshButton: RefreshButton { get }

    func addRefreshButton()
}

extension Refreshable {
    func addRefreshButton() {
        addSubview(refreshButton)

        refreshButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.width.height.equalTo(FrameResource.userTrackingButtonSize)
        }
    }
}
