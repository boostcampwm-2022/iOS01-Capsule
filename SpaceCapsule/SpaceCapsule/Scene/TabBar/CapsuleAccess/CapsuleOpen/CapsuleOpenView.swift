//
//  CapsuleOpenView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import AVFoundation
import SnapKit
import UIKit

final class CapsuleOpenView: UIView, BaseView, UnOpenable {
    var thumbnailImageView = ThemeThumbnailImageView(frame: .zero, width: UIScreen.main.bounds.width * FrameResource.capsuleThumbnailWidthRatio)

    var descriptionLabel = {
        let label = ThemeLabel(text: nil, size: FrameResource.fontSize140, color: .themeGray300)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

    let blurEffectView = CapsuleBlurEffectView()

    var lockImageView = {
        let lockImageView = UIImageView()
        lockImageView.image = .lock
        lockImageView.tintColor = .themeGray200
        return lockImageView
    }()

    var dateLabel = {
        let dateLabel = ThemeLabel(text: nil, size: FrameResource.fontSize80, color: .themeGray200)
        dateLabel.textAlignment = .center
        return dateLabel
    }()

    var openButton = {
        let button = UIButton()
        button.titleLabel?.font = .themeFont(ofSize: FrameResource.fontSize100)
        button.setTitle("열기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .themeColor200
        button.layer.cornerRadius = FrameResource.commonCornerRadius

        return button
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

    func configure() {
        backgroundColor = .themeBackground
    }

    func configure(capsuleCellItem: ListCapsuleCellItem) {
        if let thumbnailURL = capsuleCellItem.thumbnailImageURL {
            thumbnailImageView.imageView.kr.setImage(with: thumbnailURL, placeholder: .empty, scale: FrameResource.openableImageScale)
        }

        descriptionLabel.text = """
        \(capsuleCellItem.memoryDate.dateString)
        \(capsuleCellItem.address) 에서의
        추억을 담은 캡슐
        """
        descriptionLabel.asFontColor(
            targetStringList: [capsuleCellItem.memoryDate.dateString, capsuleCellItem.address],
            size: FrameResource.fontSize140,
            color: .themeGray400
        )
        dateLabel.text = "밀봉시간: \(capsuleCellItem.closedDate.dateTimeString)"
        
        if !capsuleCellItem.isOpenable() {
            openButton.backgroundColor = .themeGray200
//            openButton.isEnabled = false
            applyUnOpenableEffect()
        }
    }

    func addSubViews() {
        [thumbnailImageView, descriptionLabel, openButton].forEach {
            addSubview($0)
        }
    }

    func makeConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(AnimationResource.fromOriginY)
            $0.width.equalTo(UIScreen.main.bounds.width * FrameResource.capsuleThumbnailWidthRatio)
            $0.height.equalTo(UIScreen.main.bounds.width * FrameResource.capsuleThumbnailWidthRatio * FrameResource.capsuleThumbnailHWRatio)
        }

        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.centerY).multipliedBy(0.7)
                .offset(FrameResource.capsuleThumbnailHeight / 2 + AnimationResource.capsuleMoveHeight)
            $0.bottom.equalTo(openButton.snp.top).offset(-FrameResource.spacing200).priority(999)
        }

        openButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-FrameResource.spacing200)
            $0.height.equalTo(FrameResource.buttonHeight)
        }
    }

    func animate() {
        UIView.animate(withDuration: AnimationResource.capsuleMoveDuration, animations: {
            self.layoutIfNeeded()
            self.thumbnailImageView.center.y = (self.frame.height * AnimationResource.destinationHeightRatio)
        }, completion: { _ in
            UIView.animate(withDuration: AnimationResource.capsuleMoveDuration,
                           delay: 0,
                           options: [.repeat, .autoreverse]
            ) {
                self.thumbnailImageView.transform = .init(translationX: 0, y: AnimationResource.capsuleMoveHeight)
            }
        })
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
