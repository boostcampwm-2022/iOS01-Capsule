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
        
        guard let cv = collectionView else { return }
        self.itemSize = CGSize(width: FrameResource.detailImageViewWidth,
                               height: FrameResource.detailImageViewHeight)
        
        self.minimumInteritemSpacing = FrameResource.spacing400
        self.minimumLineSpacing = FrameResource.spacing200 // cell간의 간격
        
        self.sectionInset = UIEdgeInsets(top: 0.0,
                                         left: 0.0,
                                         bottom: self.minimumInteritemSpacing,
                                         right: 0.0)
        
        self.sectionInsetReference = .fromSafeArea
        self.scrollDirection = .horizontal
    }
}
