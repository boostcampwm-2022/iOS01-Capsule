//
//  CapsuleCell.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/22.
//

import SnapKit
import UIKit

final class ListCapsuleCell: UICollectionViewCell, UnOpenable {
    lazy var thumbnailImageView = ThemeThumbnailImageView(frame: .zero, width: FrameResource.listCapsuleCellWidth)

    lazy var descriptionLabel = {
        let label = ThemeLabel(size: FrameResource.fontSize80, color: .themeBlack)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    var blurEffectView = CapsuleBlurEffectView()

    lazy var lockImageView = {
        let lockImageView = UIImageView()
        lockImageView.image = .lock
        lockImageView.tintColor = .themeGray200
        return lockImageView
    }()

    lazy var dateLabel = {
        let dateLabel = ThemeLabel( size: 12, color: .themeGray200)
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

    func configure(capsuleCellItem: ListCapsuleCellItem) {
        if let thumbnailURL = capsuleCellItem.thumbnailImageURL {
            thumbnailImageView.imageView.kr.setImage(with: thumbnailURL, placeholder: .empty, scale: FrameResource.openableImageScale)
        }
        descriptionLabel.text = "\(capsuleCellItem.memoryDate.dateString)\n\(capsuleCellItem.address)에서"
        dateLabel.text = "밀봉시간: \(capsuleCellItem.closedDate.dateTimeString)"
        if !capsuleCellItem.isOpenable() {
            applyUnOpenableEffect()
        }
    }
}
