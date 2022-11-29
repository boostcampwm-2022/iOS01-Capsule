//
//  ContentImageFlowLayout.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/29.
//

import UIKit

final class ContentImageFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        self.itemSize = CGSize(width: 200, height: collectionView.bounds.inset(by: collectionView.layoutMargins).size.width)
        
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing,
                                         left: 0.0,
                                         bottom: 0.0,
                                         right: 0.0)
        
        self.sectionInsetReference = .fromSafeArea
    }
}
