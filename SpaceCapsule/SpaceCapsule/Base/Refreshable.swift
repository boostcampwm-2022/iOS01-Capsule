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
    private var rotationAnimationKey: String {
        return "rotate"
    }
    
    func addRefreshButton() {
        addSubview(refreshButton)

        refreshButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.width.height.equalTo(FrameResource.userTrackingButtonSize)
        }
    }
    
    func rotateRefreshButton() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.4
        animation.fillMode = .both
        animation.repeatCount = .infinity
        animation.values = [0, Double.pi * 2]
        let moments = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        animation.keyTimes = moments
        
        self.refreshButton.layer.add(animation, forKey: rotationAnimationKey)
    }
    
    func stopRotatingRefreshButton() {
        self.refreshButton.layer.removeAnimation(forKey: rotationAnimationKey)
    }
}
