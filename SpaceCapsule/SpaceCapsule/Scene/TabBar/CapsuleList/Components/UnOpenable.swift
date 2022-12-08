//
//  UnOpenable.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/03.
//

import SnapKit
import UIKit

protocol UnOpenable: UIView {
    var thumbnailImageView: ThemeThumbnailImageView { get }
    var blurEffectView: CapsuleBlurEffectView { get }
    var lockImageView: UIImageView { get }
    var dateLabel: ThemeLabel {get} 
    func applyUnOpenableEffect()
}

extension UnOpenable {
    func applyUnOpenableEffect() {
        [blurEffectView, lockImageView, dateLabel].forEach { [weak self] in
            self?.thumbnailImageView.imageView.addSubview($0)
        }
        
        blurEffectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        lockImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.3)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lockImageView.snp.bottom).offset(FrameResource.verticalPadding)
        }
    }
}
