//
//  CapsuleCell.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/22.
//

import SnapKit
import UIKit

final class ListCapsuleCell: UICollectionViewCell, UnOpenable {
    static let cellIdentifier = "ListCapsuleCell"

    lazy var thumbnailImageView = ThemeThumbnailImageView(frame: .zero, width: FrameResource.listCapsuleCellWidth)

    lazy var descriptionLabel = {
        let label = ThemeLabel(text: "xxxx년 x월 x일\nxx시 xx구에서", size: FrameResource.fontSize80, color: .themeBlack)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    lazy var blurEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = FrameResource.listCapsuleCellWidth / 2
        blurEffectView.clipsToBounds = true
        blurEffectView.alpha = FrameResource.blurEffectAlpha
        return blurEffectView
    }()

    lazy var lockImageView = {
        let lockImageView = UIImageView()
        lockImageView.image = .lock
        lockImageView.tintColor = .themeGray200
        return lockImageView
    }()

    lazy var dateLabel = {
        let dateLabel = ThemeLabel(text: "밀봉시간:xxxx년 xx월 xx일", size: FrameResource.fontSize80, color: .themeGray200)
        dateLabel.textAlignment = .center
        return dateLabel
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
        [thumbnailImageView, descriptionLabel].forEach { [weak self] in
            self?.contentView.addSubview($0)
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
        }
        descriptionLabel.text = "\(capsuleCellModel.memoryDate.dateString)\n\(capsuleCellModel.address)에서"
        dateLabel = ThemeLabel(text: "밀봉시간:\(capsuleCellModel.closedDate.dateString)", size: FrameResource.fontSize80, color: .themeGray200)
        if !capsuleCellModel.isOpenable() {
            applyUnOpenableEffect()
        }
    }

//    func applyUnOpenableEffect() {
//
//    }
}
