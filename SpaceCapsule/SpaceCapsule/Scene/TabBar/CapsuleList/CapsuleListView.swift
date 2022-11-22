//
//  CapsuleListView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import SnapKit

final class CapsuleListView: UIView, BaseView {
    let sortBarButtonItem = {
        let button = UIButton()
        button.titleLabel?.font = .themeFont(ofSize: 15)
        button.setTitle("가까운 순", for: .normal)
        button.setTitleColor(.themeBlack, for: .normal)
        button.setImage(.sort, for: .normal)
        button.tintColor = .themeBlack
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(CapsuleCell.self, forCellWithReuseIdentifier: CapsuleCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
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
        collectionView.backgroundColor = .themeBackground
        configureFlowLayout()
    }
    
    func configureFlowLayout() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
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
