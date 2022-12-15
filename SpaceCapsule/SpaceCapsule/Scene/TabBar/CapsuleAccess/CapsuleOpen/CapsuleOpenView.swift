//
//  CapsuleOpenView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import AVFoundation
import SnapKit
import UIKit

final class CapsuleOpenView: CapsuleThumbnailView, BaseView, UnOpenable {
    let blurEffectView = CapsuleBlurEffectView(width: UIScreen.main.bounds.width * FrameResource.capsuleThumbnailWidthRatio)

    var lockImageView = LockImageView()

    var closedDateLabel = {
        let dateLabel = ThemeLabel(size: FrameResource.fontSize80, color: .themeGray200)
        dateLabel.textAlignment = .center
        dateLabel.numberOfLines = 0

        return dateLabel
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(item: Item, isOpenable: Bool) {
        bottomButton.setTitle("열기", for: .normal)

        descriptionLabel.text = """
        \(item.memoryDateString)
        \(item.simpleAddress) 에서의
        추억이 담긴 캡슐을 보관하였습니다.
        """

        closedDateLabel.text = "밀봉시간 \(item.closedDateString)"

        if !isOpenable {
            applyUnopenableEffect(superview: thumbnailImageView)
        }

        super.configure(item: item)
    }

    func shakeAnimate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

        let keyPath = "position"

        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = AnimationResource.capsuleShakeDuration
        animation.repeatCount = AnimationResource.capsuleShakeRepeat
        animation.autoreverses = true

        animation.fromValue = CGPoint(
            x: thumbnailImageView.center.x - AnimationResource.capsuleShakeWidth,
            y: thumbnailImageView.center.y
        )

        animation.toValue = CGPoint(
            x: thumbnailImageView.center.x + AnimationResource.capsuleShakeWidth,
            y: thumbnailImageView.center.y
        )
        animation.isRemovedOnCompletion = true
        
        thumbnailImageView.layer.add(animation, forKey: keyPath)

    }
}
