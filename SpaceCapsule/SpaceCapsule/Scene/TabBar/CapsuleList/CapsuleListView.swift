//
//  CapsuleListView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import SnapKit

final class CapsuleListView: UIView, BaseView {
    
    let collectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // collectionView.regi 아이템 셀
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        configure()
        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .themeBackground
        configureFlowLayout()
    }
    
    func configureFlowLayout() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = collectionViewFlowLayout
    }
    
    func addSubViews() {
        [collectionView].forEach {
            addSubview($0)
        }
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
        }
    }
    
}
