//
//  HomeCapsuleCell.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/29.
//

import SnapKit
import UIKit

final class HomeCapsuleCell: UICollectionViewCell {
    var uuid: String?
    
    var thumbnailImageView = ThemeThumbnailImageView(frame: .zero, width: FrameResource.homeCapsuleCellWidth)

    var titleLabel = {
        let label = ThemeLabel(text: "가장 오래된 캡슐", size: FrameResource.fontSize120, color: .themeColor200)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    var descriptionLabel = {
        let label = ThemeLabel(text: "2017.10.23 서울시 성동구\nD+1784", size: FrameResource.fontSize120, color: .themeGray300)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        [thumbnailImageView, titleLabel, descriptionLabel].forEach {
            self.contentView.addSubview($0)
        }
    }

    func makeConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(FrameResource.homeCapsuleCellWidth)
            $0.height.equalTo(FrameResource.homeCapsuleCellThumbnailHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(FrameResource.verticalPadding)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(FrameResource.verticalPadding)
            $0.centerX.equalToSuperview()
        }
    }

    func configure(capsuleCellModel: HomeCapsuleCellItem) {
        uuid = capsuleCellModel.uuid
        
        if let thumbnailURL = capsuleCellModel.thumbnailImageURL {
            thumbnailImageView.imageView.kr.setImage(with: thumbnailURL, scale: FrameResource.openableImageScale)
        }
        titleLabel.text = capsuleCellModel.type.title
        descriptionLabel.text = capsuleCellModel.description()
        
        if !capsuleCellModel.isOpenable() {
            applyUnOpenableEffect(closeDate: capsuleCellModel.closedDate.dateString)
        }
    }

    func applyUnOpenableEffect(closeDate: String) {
        applyBlurEffect()
        applyLockImage()
        applyCapsuleDate(closeDate: closeDate)
    }

    private func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = FrameResource.listCapsuleCellWidth / 2
        blurEffectView.clipsToBounds = true
        thumbnailImageView.imageView.addSubview(blurEffectView)

        blurEffectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }

    private func applyLockImage() {
        let lockImageView = UIImageView()
        lockImageView.image = UIImage(systemName: "lock.fill")
        lockImageView.tintColor = .themeGray300
        thumbnailImageView.imageView.addSubview(lockImageView)

        lockImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(thumbnailImageView.imageView.snp.width).multipliedBy(0.3)
        }
    }

    private func applyCapsuleDate(closeDate: String) {
        let dateLabel = ThemeLabel(text: "밀봉시간:\(closeDate)", size: FrameResource.fontSize120, color: .themeGray300)
        dateLabel.textAlignment = .center
        thumbnailImageView.imageView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.4)
        }
    }
}
