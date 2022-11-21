//
//  CapsuleOpenView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import SnapKit

final class CapsuleOpenView: UIView, BaseView {
    var thumbnailImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = FrameResource.capsuleThumbnailCornerRadius
        imageView.clipsToBounds = true
        imageView.image = UIImage.logoWithBG
        return imageView
    }()
    
    var thumbnailImageContainerView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.5
        view.layer.cornerRadius = FrameResource.capsuleThumbnailCornerRadius
        return view
    }()
    
    var descriptionLabel = {
        let label = ThemeLabel(text: "xxxx년 x월 x일\nxx시 xx구 에서의\n추억을 담은 캡슐", size: 28, color: .themeGray300)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    var openButton = {
        let button = UIButton()
        button.titleLabel?.font = .themeFont(ofSize: 20)
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

    func addSubViews() {
        [thumbnailImageContainerView, descriptionLabel, openButton].forEach {
            addSubview($0)
        }
        thumbnailImageContainerView.addSubview(thumbnailImageView)
    }

    func makeConstraints() {
        thumbnailImageContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.width.equalTo(FrameResource.capsuleThumbnailWidth)
            $0.height.equalTo(FrameResource.capsuleThumbnailHeigth)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(50)
        }
        
        openButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            $0.height.equalTo(FrameResource.buttonHeight)
        }
    }
    
    // TODO: Capsule 인자로 받아서 configure하기
    
    func applyUnOpenableEffect() {
        openButton.backgroundColor = .themeGray200
        applyBlurEffect()
        applyLockImage()
        applyCapsuleDate()
    }
    
    private func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = FrameResource.capsuleThumbnailCornerRadius
        blurEffectView.clipsToBounds = true
    
        thumbnailImageView.addSubview(blurEffectView)
        
        blurEffectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
    
    private func applyLockImage() {
        let lockImageView = UIImageView()
        lockImageView.image = UIImage(systemName: "lock.fill")
        lockImageView.tintColor = .themeGray300
        
        thumbnailImageView.addSubview(lockImageView)
        
        lockImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
    
    private func applyCapsuleDate() {
        let dateLabel = ThemeLabel(text: "밀봉시간:xxxx년 x월 x일", size: 18, color: .themeGray300)
        dateLabel.textAlignment = .center
        
        thumbnailImageView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.2)
        }
    }
}
