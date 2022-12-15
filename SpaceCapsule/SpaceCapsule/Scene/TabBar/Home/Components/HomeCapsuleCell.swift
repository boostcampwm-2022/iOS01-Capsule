//
//  HomeCapsuleCell.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/29.
//

import SnapKit
import UIKit

final class HomeCapsuleCell: UICollectionViewCell, UnOpenable {
    var uuid: String?

    var thumbnailImageView = ThumbnailImageView(frame: .zero, width: FrameResource.homeCapsuleCellWidth)

    var titleLabel = {
        let label = ThemeLabel(text: "가장 오래된 캡슐", size: FrameResource.fontSize120, color: .themeColor200)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    var descriptionLabel = {
        let label = ThemeLabel(text: "2017.10.23 서울시 성동구\nD+1784", size: FrameResource.fontSize100, color: .themeGray300)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

    var closedDateLabel = {
        let dateLabel = ThemeLabel(text: nil, size: FrameResource.fontSize100, color: .themeGray200)
        dateLabel.textAlignment = .center
        return dateLabel
    }()

    var blurEffectView = CapsuleBlurEffectView(width: FrameResource.homeCapsuleCellWidth)

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

        removeUnopenableEffect(superview: thumbnailImageView)
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

        thumbnailImageView.imageView.kr.setImage(
            with: capsuleCellModel.thumbnailImageURL,
            placeholder: .empty,
            scale: FrameResource.openableImageScale
        )

        closedDateLabel.text = "밀봉시간:\(capsuleCellModel.closedDate.dateString)"
        titleLabel.text = capsuleCellModel.type.title
        descriptionLabel.text = capsuleCellModel.description

        if !capsuleCellModel.isOpenable {
            applyUnopenableEffect(superview: thumbnailImageView)
        }
    }
}
