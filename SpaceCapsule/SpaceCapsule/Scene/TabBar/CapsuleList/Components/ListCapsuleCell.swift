//
//  CapsuleCell.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/22.
//

import UIKit
import SnapKit

final class ListCapsuleCell: UICollectionViewCell {
    static let cellIdentifier = "ListCapsuleCell"
    
    var thumbnailImageView = ThemeThumbnailImageView(frame: .zero, width: FrameResource.listCapsuleCellWidth)
    
    var descriptionLabel = {
        let label = ThemeLabel(text: "xxxx년 x월 x일\nxx시 xx구에서", size: FrameResource.fontSize80, color: .themeBlack)
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
        [thumbnailImageView, descriptionLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    func makeConstraints() {
        
        thumbnailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.width.equalTo(FrameResource.listCapsuleCellWidth)
            $0.height.equalTo(FrameResource.listCapsuleCellHeight)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(FrameResource.verticalPadding)
            $0.centerX.equalToSuperview()
        }
    }

    func configure(capsuleCellModel: ListCapsuleCellModel) {
        if let thumbnailURL = capsuleCellModel.thumbnailImageURL {
            thumbnailImageView.imageView.kr.setImage(with: thumbnailURL, scale: FrameResource.openableImageScale)
        } else {
            thumbnailImageView.imageView.image = .logoWithBG
        }
        
        descriptionLabel.text = "\(capsuleCellModel.memoryDate.dateString)\n\(capsuleCellModel.address)에서"
        thumbnailImageView.imageView.subviews.forEach {
            $0.removeFromSuperview()
        }
        if capsuleCellModel.isOpenable == false {
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
        let dateLabel = ThemeLabel(text: "밀봉시간:\(closeDate)", size: FrameResource.fontSize80, color: .themeGray300)
        dateLabel.textAlignment = .center
        thumbnailImageView.imageView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.4)
        }
    }
}
