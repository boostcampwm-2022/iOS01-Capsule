//
//  AddImageCollectionViewFooter.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/19.
//

import SnapKit
import UIKit

class AddImageButtonCell: UICollectionViewCell {
    let addImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .addImage
        imageView.tintColor = .themeGray300

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = FrameResource.commonCornerRadius
        layer.borderWidth = FrameResource.commonBorderWidth
        layer.borderColor = UIColor.themeGray300?.cgColor

        backgroundColor = .themeGray100

        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        addSubview(addImageView)
    }

    private func makeConstraints() {
        addImageView.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.center.equalToSuperview()
        }
    }
}
