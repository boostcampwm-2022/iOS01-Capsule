//
//  UnOpenable.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/03.
//

import SnapKit
import UIKit

protocol UnOpenable: UIView {
    var blurEffectView: CapsuleBlurEffectView { get }
    var lockImageView: LockImageView { get }
    var closedDateLabel: ThemeLabel { get }

    func applyUnopenableEffect(superview: UIView)
    func removeUnopenableEffect(superview: UIView)
}

extension UnOpenable {
    func applyUnopenableEffect(superview: UIView) {
        [blurEffectView, lockImageView, closedDateLabel].forEach {
            superview.addSubview($0)
        }

        blurEffectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }

        lockImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(superview.snp.width).multipliedBy(0.3)
        }

        closedDateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lockImageView.snp.bottom).offset(FrameResource.verticalPadding)
        }
    }

    func removeUnopenableEffect(superview: UIView) {
        superview.subviews.forEach {
            if $0 is CapsuleBlurEffectView || $0 is LockImageView || $0 is ThemeLabel {
                $0.removeFromSuperview()
            }
        }
    }
}
