//
//  AddImageCollectionViewCell.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/19.
//

import KingReceiver
import SnapKit
import UIKit

final class AddImageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .themeBlack

        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(data: Data) {
        imageView.kr.setImage(
            with: data,
            placeholder: .empty,
            to: frame.size,
            scale: FrameResource.openableImageScale
        )
    }

    private func addSubViews() {
        addSubview(imageView)
    }

    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
