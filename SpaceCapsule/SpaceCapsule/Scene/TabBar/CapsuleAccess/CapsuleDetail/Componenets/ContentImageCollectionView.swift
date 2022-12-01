//
//  ContentImageCollectionView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/29.
//

import UIKit
import SnapKit

final class ContentImageCollectionView: UICollectionView {
    required init(frame: CGRect) {
        let customLayout = ContentImageFlowLayout()
        super.init(frame: frame, collectionViewLayout: customLayout)
        register(ContentImageCell.self, forCellWithReuseIdentifier: ContentImageCell.identifier)
        
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
}
