//
//  CapsuleCell.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/22.
//

import UIKit
import SnapKit
import RxSwift

final class CapsuleCell: UICollectionViewCell {
    static let identifier = "CapsuleCell"
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubview() {
        thumbnailImageContainerView.addSubview(thumbnailImageView)
        [thumbnailImageContainerView].forEach {
            self.contentView.addSubview($0)
        }
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
    }
    // TODO: 객체를 인자로 받고 셀을 업데이트 해야 한다.
    func configureCell() {
        
    }
    
    func applyUnOpenableEffect() {
        applyBlurEffect()
        applyLockImage()
        applyCapsuleDate()
    }
    
    private func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
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
