//
//  ContentImageFlowLayout.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/29.
//

import UIKit

final class DetailImageFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        self.itemSize = CGSize(width: FrameResource.detailImageViewWidth,
                               height: FrameResource.detailImageViewHeight)
        
        self.minimumLineSpacing = FrameResource.spacing200
        self.sectionInset = UIEdgeInsets(top: 0.0,
                                         left: FrameResource.detailContentHInset,
                                         bottom: 0.0,
                                         right: FrameResource.detailContentHInset)
        
        self.sectionInsetReference = .fromSafeArea
        self.scrollDirection = .horizontal
    }
}
