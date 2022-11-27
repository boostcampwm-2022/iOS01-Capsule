//
//  CapsuleCell.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/22.
//

import UIKit
import SnapKit

final class CapsuleCell: UICollectionViewCell {
    static let cellIdentifier = "CapsuleCell"
    
    var thumbnailImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = FrameResource.capsuleCellWidth / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage.logoWithBG
        return imageView
    }()
    
    var thumbnailImageContainerView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.5
        view.layer.cornerRadius = FrameResource.capsuleCellWidth / 2
        return view
    }()
    
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
        thumbnailImageContainerView.addSubview(thumbnailImageView)
        [thumbnailImageContainerView, descriptionLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    func makeConstraints() {
        thumbnailImageContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.width.equalTo(FrameResource.capsuleCellWidth)
            $0.height.equalTo(FrameResource.capsuleCellHeight)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageContainerView.snp.bottom).offset(FrameResource.verticalPadding)
            $0.centerX.equalToSuperview()
        }
    }

    func configure(capsuleCellModel: CapsuleCellModel) {
        thumbnailImageView.image = capsuleCellModel.thumbnailImage
        descriptionLabel.text = "\(capsuleCellModel.memoryDate)\n\(capsuleCellModel.address)에서"
        thumbnailImageView.subviews.forEach {
            $0.removeFromSuperview()
        }
        if capsuleCellModel.isOpenable == false {
            applyUnOpenableEffect(closeDate: capsuleCellModel.closedDate)
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
        blurEffectView.layer.cornerRadius = FrameResource.capsuleCellWidth / 2
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
            $0.width.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.3)
        }
    }
    
    private func applyCapsuleDate(closeDate: String) {
        let dateLabel = ThemeLabel(text: "밀봉시간:\(closeDate)", size: FrameResource.fontSize80, color: .themeGray300)
        dateLabel.textAlignment = .center
        thumbnailImageView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.4)
        }
    }
}
