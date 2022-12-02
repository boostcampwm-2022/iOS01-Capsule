//
//  ContentImageCollectionView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/29.
//

import SnapKit
import UIKit

final class DetailImageCollectionView: UICollectionView {

    required init(frame: CGRect) {
        let customLayout = DetailImageFlowLayout()
        super.init(frame: frame, collectionViewLayout: customLayout)
        register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.identifier)

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        alwaysBounceHorizontal = true
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
}
