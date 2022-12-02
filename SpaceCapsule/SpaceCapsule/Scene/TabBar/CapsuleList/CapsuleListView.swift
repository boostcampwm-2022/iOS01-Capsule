//
//  CapsuleListView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class CapsuleListView: UIView, BaseView {
    let sortBarButtonItem = {
        let button = UIButton()
        button.titleLabel?.font = .themeFont(ofSize: FrameResource.fontSize80)
        button.setTitle(SortPolicy.nearest.description, for: .normal)
        button.setTitleColor(.themeBlack, for: .normal)
        button.setImage(.sort, for: .normal)
        button.tintColor = .themeBlack
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .leading
        return button
    }()

    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(ListCapsuleCell.self, forCellWithReuseIdentifier: ListCapsuleCell.cellIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        collectionViewFlowLayout.minimumLineSpacing = FrameResource.verticalPadding
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(
            top: FrameResource.verticalPadding,
            left: FrameResource.listCapsuleHorizontalInset,
            bottom: 0,
            right: FrameResource.listCapsuleHorizontalInset)
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
