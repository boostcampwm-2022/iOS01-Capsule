//
//  CapsuleOpenView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import SnapKit
import AVFoundation

final class CapsuleOpenView: UIView, BaseView {
    var thumbnailImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = FrameResource.capsuleThumbnailCornerRadius
        imageView.clipsToBounds = true
        imageView.image = UIImage.logoWithBG
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var thumbnailImageContainerView = {
        let view = UIView()
        view.layer.shadowOffset = FrameResource.shadowOffset
        view.layer.shadowRadius = FrameResource.shadowRadius
        view.layer.shadowOpacity = FrameResource.shadowOpacity
        view.layer.cornerRadius = FrameResource.capsuleThumbnailCornerRadius
        return view
    }()
    
    var descriptionLabel = {
        let label = ThemeLabel(text: "xxxx년 x월 x일\nxx시 xx구 에서의\n추억을 담은 캡슐", size: FrameResource.fontSize140, color: .themeGray300)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
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
    
    func configure(capsuleCellModel: ListCapsuleCellModel) {
        if let thumbnailURL = capsuleCellModel.thumbnailImageURL {
            thumbnailImageView.kr.setImage(with: thumbnailURL, scale: FrameResource.openableImageScale)
        } else {
            thumbnailImageView.image = .logoWithBG
        }
        descriptionLabel.text = """
        \(capsuleCellModel.memoryDate.dateString)
        \(capsuleCellModel.address) 에서의
        추억을 담은 캡슐
        """
        descriptionLabel.asFontColor(
            targetStringList: [capsuleCellModel.memoryDate.dateString, capsuleCellModel.address],
            size: FrameResource.fontSize140,
            color: .themeGray400
        )
        if capsuleCellModel.isOpenable() == false {
            applyUnOpenableEffect(capsuleCellModel: capsuleCellModel)
        }
        
    }

    func addSubViews() {
        [thumbnailImageContainerView, descriptionLabel, openButton].forEach {
            addSubview($0)
        }
        thumbnailImageContainerView.addSubview(thumbnailImageView)
    }

    func makeConstraints() {
        thumbnailImageContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(AnimationResource.fromOriginY)
            $0.width.equalTo(FrameResource.capsuleThumbnailWidth)
            $0.height.equalTo(FrameResource.capsuleThumbnailHeight)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(openButton.snp.top).offset(-FrameResource.buttonHeight)
        }
        
        openButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.buttonHeight)
            $0.height.equalTo(FrameResource.buttonHeight)
        }
    }
    
    func applyUnOpenableEffect(capsuleCellModel: ListCapsuleCellModel) {
        openButton.backgroundColor = .themeGray200
        applyBlurEffect()
        applyLockImage()
        applyCapsuleDate(capsuleCellModel: capsuleCellModel)
    }
    
    private func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = FrameResource.capsuleThumbnailCornerRadius
        blurEffectView.clipsToBounds = true
        blurEffectView.alpha = FrameResource.blurEffectAlpha
        thumbnailImageView.addSubview(blurEffectView)
        
        blurEffectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
    
    private func applyLockImage() {
        let lockImageView = UIImageView()
        lockImageView.image = .lock
        lockImageView.tintColor = .themeGray200
        
        thumbnailImageView.addSubview(lockImageView)
        
        lockImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.3)
        }
    }
    
    private func applyCapsuleDate(capsuleCellModel: ListCapsuleCellModel) {
        let dateLabel = ThemeLabel(text: "밀봉시간:\(capsuleCellModel.closedDate.dateString)",
                                   size: FrameResource.fontSize90, color: .themeGray200)
        dateLabel.textAlignment = .center
        
        thumbnailImageView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.2)
        }
    }
    
    func animate() {
        UIView.animate(withDuration: AnimationResource.capsuleMoveDuration, animations: {
            self.layoutIfNeeded()
            self.thumbnailImageContainerView.center.y = (self.frame.height * AnimationResource.destinationHeightRatio)
        }, completion: { _ in
            UIView.animate(withDuration: AnimationResource.capsuleMoveDuration,
                           delay: 0,
                           options: [.repeat, .autoreverse]
            ) {
                self.thumbnailImageContainerView.transform = .init(translationX: 0, y: AnimationResource.capsuleMoveHeight)
            }
        })
    }
    
    func shakeAnimate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        let keyPath = "shake"
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = AnimationResource.capsuleShakeDuration
        animation.repeatCount = AnimationResource.capsuleShakeRepeat
        animation.autoreverses = true
        animation.fromValue = CGPoint(
            x: thumbnailImageContainerView.center.x - AnimationResource.capsuleShakeWidth,
            y: thumbnailImageContainerView.center.y
        )
        animation.toValue = CGPoint(
            x: thumbnailImageContainerView.center.x + AnimationResource.capsuleShakeWidth,
            y: thumbnailImageContainerView.center.y
        )
        thumbnailImageContainerView.layer.add(animation, forKey: keyPath)
    }
}
