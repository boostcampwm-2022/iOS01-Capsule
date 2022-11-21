//
//  AddImageCollectionViewFooter.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/19.
//

import SnapKit
import UIKit

class AddImageButtonCell: UICollectionViewCell {
    let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(.addImage, for: .normal)
        button.tintColor = .themeColor300

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor

        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        addSubview(addImageButton)
    }

    private func makeConstraints() {
        addImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
