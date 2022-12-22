//
//  MyCollectionView.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/12/22.
//

import UIKit

class CustomCollectionView: UICollectionView {

    private var reloadDataCompletionBlock: (() -> Void)?
    
    func reloadDataWithCompletion(_ complete: @escaping () -> Void) {
        reloadDataCompletionBlock = complete
        super.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
}
