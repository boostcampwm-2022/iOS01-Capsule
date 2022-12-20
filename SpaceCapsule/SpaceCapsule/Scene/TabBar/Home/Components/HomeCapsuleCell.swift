//
//  HomeCapsuleCell.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/29.
//

import KingReceiver
import SnapKit
import UIKit

final class HomeCapsuleCell: UICollectionViewCell, UnOpenable {    
    var uuid: String?
    
    var thumbnailImageView = ThemeThumbnailImageView(frame: .zero, width: FrameResource.homeCapsuleCellWidth)

    var titleLabel = {
        let label = ThemeLabel(size: FrameResource.fontSize120, color: .themeColor200)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    var descriptionLabel = {
        let label = ThemeLabel(size: FrameResource.fontSize100, color: .themeGray300)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    var dateLabel = {
        let dateLabel = ThemeLabel(size: FrameResource.fontSize80, color: .themeGray200)
        dateLabel.textAlignment = .center
        return dateLabel
    }()
    
    var blurEffectView = CapsuleBlurEffectView()
    
    var lockImageView = {
        let lockImageView = UIImageView()
        lockImageView.image = .lock
        lockImageView.tintColor = .themeGray200
        return lockImageView
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.imageView.subviews.forEach {
            $0.removeFromSuperview()
        }
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
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(FrameResource.verticalPadding * 2)
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
            thumbnailImageView.imageView.kr.setImage(with: thumbnailURL, placeholder: .empty, scale: FrameResource.openableImageScale)
        }
        dateLabel.text = "밀봉시간: \(capsuleCellModel.closedDate.dateTimeString)"
        titleLabel.text = capsuleCellModel.type.title
        descriptionLabel.text = capsuleCellModel.description()
        
        if !capsuleCellModel.isOpenable() {
            applyUnOpenableEffect()
        }
    }
}
